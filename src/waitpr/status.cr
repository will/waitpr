require "./check"

module WaitPR
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
        puts "No checks found yet. If you just pushed, try again."
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

    def initialize(@checks)
      sizes = checks.map(&.name.size) << 0
      @name_size = sizes.max
    end

    def finished?
      checks.all? &.finished?
    end

    def to_s(io : IO)
      checks.each do |c|
        io << c.name.rjust(name_size) << "\t" << c.display
        io << "\t" << c.url unless c.finished? && c.succeeded?
        io << "\n"
      end
    end
  end
end
