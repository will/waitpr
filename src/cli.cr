require "./waitpr"
require "option_parser"

OptionParser.parse do |parser|
  parser.banner = "Usage: waitpr [arguments]"
  parser.on("-v", "--version", "Show the version") do
    puts "waitpr v#{WaitPR::VERSION}"
    exit
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

WaitPR::Program.new.run
