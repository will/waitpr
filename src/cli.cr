#!/usr/bin/env crystal
require "./waitpr"
require "option_parser"

prog = WaitPR::Program.new

OptionParser.parse do |parser|
  parser.banner = "Usage: waitpr [arguments]"
  parser.on("--version", "Show the version") do
    puts "waitpr v#{WaitPR::VERSION}"
    exit
  end

  parser.on("-x", "--no-notify", "Disable notifications") do
    prog.notify = false
  end

  parser.on("-n SECONDS", "--notify=SECONDS", "Notify when finished if jobs take longer than n seconds (default 60)") do |arg|
    if error_message = (prog.notify_cutoff = arg)
      STDERR.puts error_message
      exit 1
    end
  end

  parser.on("-h", "--help", "Show this help") do
    puts parser
    exit
  end
  parser.invalid_option do |flag|
    STDERR.puts "ERROR: #{flag} is not a valid option."
    STDERR.puts parser
    exit(1)
  end
end

prog.run
