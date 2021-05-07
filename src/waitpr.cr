module WaitPR
  VERSION = "0.1.0"
end

require "./waitpr/program"

if PROGRAM_NAME.ends_with? "waitpr"
  Signal::INT.trap { print "\e[?25h" }
  at_exit { print "\e[?25h" }
  WaitPR::Program.new.run
end
