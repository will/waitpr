require "./status"

module WaitPR
  class Program
    property done = false
    property count = 0
    property start : Time::Span
    property notify_cutoff : Time::Span = 1.minute
    property notify = true

    SPINNER = ["🕛 ", "🕐 ", "🕑 ", "🕒 ", "🕓 ", "🕔 ", "🕕 ", "🕖 ", "🕗 ", "🕘 ", "🕙 ", "🕚 "]

    def initialize
      @start = Time.monotonic
    end

    def run
      lines_to_clear = 0
      duration = start
      last = Time.monotonic

      while !done
        status = Status.fetch_wait
        now = Time.monotonic
        last_run_duration = last - now
        last = now
        duration = now - start
        self.done = status.finished?

        print "\e[#{lines_to_clear}A\e[J" if lines_to_clear > 0
        if done
          print "done!"
        else
          print "#{SPINNER[count % SPINNER.size]}  waiting"
        end
        puts " #{Time.monotonic - start}"

        print status
        lines_to_clear = status.checks.size + 1
        self.count += 1
        sleep 1.second - last_run_duration unless done
      end

      notify duration, status if notify
    end

    def notify(duration, status)
      return unless duration > notify_cutoff
      return unless status
      passed = status.checks.count(&.succeeded?)
      total = status.checks.size

      {% if flag?(:darwin) %}
        `osascript -e 'display notification "#{passed}/#{total} passed after #{duration}" with title "PR checks done"'`
      {% end %}
    end

    def notify_cutoff=(from_optparse : String)
      seconds = from_optparse.to_i { return "'#{from_optparse.inspect}' not valid" }
      return "only positive numbers are allowed" unless seconds >= 0
      @notify_cutoff = seconds.seconds
      nil
    end
  end
end
