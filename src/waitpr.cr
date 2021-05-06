require "json"

module Waitpr
  VERSION = "0.1.0"

  struct Check
    include JSON::Serializable

    getter name : String
    getter status : String
    getter conclusion : String
    @[JSON::Field(key: "detailsUrl")]
    getter url : String

    def finished?
      status == "COMPLETED"
    end

    def succeeded?
      conclusion == "SUCCESS"
    end

    def display
      case status
      when "QUEUED"
        "⏳"
      when "IN_PROGRESS"
        "⚙️"
      when "COMPLETED"
        case conclusion
        when "SUCCESS"
          "✅"
        when "FAILURE"
          "❌"
        else
          conclusion
        end
      end
    end
  end

  struct Status
    getter checks : Array(Check)
    getter name_size : Int32

    def self.fetch
      json = `gh pr view --json statusCheckRollup -q '.statusCheckRollup'`
      if json =~ /command not found/
        puts "Please install the `gh' command"
        exit 1
      end

      if json == "\n"
        puts "no checks found yet, maybe try again"
        exit 1
      elsif json == ""
        exit 1
      else
        new Array(Check).from_json(json)
      end
    rescue JSON::ParseException
      puts "bad json?"
      puts json
      exit
    end

    def initialize(@checks, @invalid = false)
      sizes = checks.map(&.name.size) << 0
      @name_size = sizes.max
    end

    def finished?
      checks.all? &.finished? && !@invalid
    end

    def to_s(io : IO)
      checks.each do |c|
        io << c.name.rjust(name_size) << "\t" << c.display
        io << "\t" << c.url unless c.finished? && c.succeeded?
        io << "\n"
      end
    end
  end

  class Program
    property done = false
    property count = 0
    property start : Time::Span

    SPINNER = ["🕛 ", "🕐 ", "🕑 ", "🕒 ", "🕓 ", "🕔 ", "🕕 ", "🕖 ", "🕗 ", "🕘 ", "🕙 ", "🕚 "]

    def initialize
      @start = Time.monotonic
    end

    def run
      print "\e[?25l" # hide cursor
      lines_to_clear = 0
      while !done
        status = Status.fetch
        duration = Time.monotonic - start
        self.done = status.finished?

        print "\e[#{lines_to_clear}A\e[J" if lines_to_clear > 0
        if done
          print "done!"
        else
          print "#{SPINNER[count % SPINNER.size]}  waiting"
        end
        puts " #{Time.monotonic - start}"

        puts status
        lines_to_clear = status.checks.size + 2
        self.count += 1
      end
    end
  end
end

Signal::INT.trap { print "\e[?25h" }
at_exit { print "\e[?25h" }
Waitpr::Program.new.run
