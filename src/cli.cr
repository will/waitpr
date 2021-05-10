#!/usr/bin/env crystal
require "./waitpr"
require "option_parser"

PROG = WaitPR::Program.new

def parse(path : String)
  contents = File.read(path)
  parse contents.split(" ").map(&.chomp), path
rescue File::NotFoundError
end

def parse(args, path = nil)
  OptionParser.parse(args) do |parser|
    parser.banner = "Usage: waitpr [arguments]"
    parser.on("--version", "Show the version") do
      puts "waitpr v#{WaitPR::VERSION}"
      exit
    end

    parser.on("-x", "--no-notify", "Disable notifications") do
      PROG.notify = false
    end

    parser.on("-n SECONDS", "--notify=SECONDS", "Notify when finished if jobs take longer than n seconds (default 60)") do |arg|
      if error_message = (PROG.notify_cutoff = arg)
        STDERR.puts error_message
        exit 1
      end
    end

    parser.on("-h", "--help", "Show this help") do
      puts parser
      puts "\nGlobal arguments can optionally be placed in ~/.config/waitpr/waitpr"
      puts "Project-local arguments can optionally be placed in .waitpr and will supersede global arguments"
      puts "Direct command arguments supersede both project-local and global"
      exit
    end

    parser.invalid_option do |flag|
      STDERR.puts "ERROR: #{flag} is not a valid option."
      STDERR.puts "  argument came from #{path}" if path
      STDERR.puts parser
      exit(1)
    end
  end
end

parse "~/.config/waitpr/waitpr"
parse ".waitpr"
parse ARGV

PROG.run
