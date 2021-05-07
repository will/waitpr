require "./status"

module WaitPR
  class Program
    property done = false
    property count = 0
    property start : Time::Span

    SPINNER = ["🕛 ", "🕐 ", "🕑 ", "🕒 ", "🕓 ", "🕔 ", "🕕 ", "🕖 ", "🕗 ", "🕘 ", "🕙 ", "🕚 "]

    def initialize
      @start = Time.monotonic
    end

    def run
      lines_to_clear = 0
      duration = start

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

      notify duration, status
    end

    def notify(duration, status)
      return unless duration > 1.minute
      return unless status
      passed = status.checks.count(&.succeeded?)
      total = status.checks.size

      {% if flag?(:darwin) %}
        `osascript -e 'display notification "#{passed}/#{total} passed after #{duration}" with title "PR checks done"'`
      {% end %}
    end
  end
end
