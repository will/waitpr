require "./check"

module WaitPR
  struct Status
    getter checks : Array(Check)
    getter name_size : Int32

    def self.fetch : Status?
      json = `gh pr view --json statusCheckRollup -q '.statusCheckRollup'`
      if json =~ /command not found/
        STDERR.puts "Please install the `gh' command"
        exit 1
      end

      if json == "\n"
        nil
      elsif json == ""
        exit 1
      else
        new Array(Check).from_json(json)
      end
    rescue JSON::ParseException
      STDERR.puts "bad json?"
      STDERR.puts json
      exit
    end

    def self.fetch_wait : Status
      times = 0
      loop do
        times += 1
        result = self.fetch
        return result if result
        if times > 5
          STDERR.puts "could not find any checks for this branch"
          exit 1
        end
        sleep 1
      end
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
