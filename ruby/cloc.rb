#!/usr/bin/env ruby

# Parse command line arguments
require 'optparse'

options = {}

OptionParser.new do |opts|
  opts.banner = "Usage: count_lines.rb [options] directory"

  opts.on("-e", "--extensions EXTENSIONS", Array, "File extensions to include") do |extensions|
    options[:extensions] = extensions
  end

  opts.on("-h", "--help", "Prints this help") do
    puts opts
    exit
  end
end.parse!

nameMapping = {
  ".c"    => 'c',
  ['.cc', '.cpp', '.cxx'] => 'c++',
  '.java' => 'java',
  '.js' => 'javascript',
  ['.md', '.markdown'] => 'markdown',
  '.py'   => 'python',
  '.txt'  => 'text'
}

# Get the directory path from the command line argument
directory_path = ARGV[0]

# Check if a directory path was provided
if directory_path.nil?
  puts "Please provide a directory path"
  exit
end

# Check if the directory exists
unless Dir.exist?(directory_path)
  puts "Directory does not exist"
  exit
end

# Get all the files in the directory that match the specified extensions
if options[:extensions]
  extensions = options[:extensions].map { |ext| ".#{ext}" }
  files = Dir.glob("#{directory_path}/**/*{#{extensions.join(',')}}")
else
  files = Dir.glob("#{directory_path}/**/*")
end

# Count the lines of code in each file for each specified extension
lines_by_extension = {}
files.each do |file_path|
  # Skip directories
  next if File.directory?(file_path)

  # Get the file extension
  extension = File.extname(file_path)

  # Open the file and read its contents
  file_contents = File.read(file_path)

  # Count the number of lines in the file
  num_lines = file_contents.lines.count

  # Add the number of lines to the total count for the extension
  if lines_by_extension[extension]
    lines_by_extension[extension] += num_lines
  else
    lines_by_extension[extension] = num_lines
  end
end

unknown_count = 0
# Output the number of lines for each extension
lines_by_extension.each do |extension, num_lines|
  # puts "#{extensionName[extension]}\t: #{num_lines} lines"
  if nameMapping.has_key?(extension)
    puts "#{nameMapping[extension]}:\t\t #{num_lines} lines"
  else
    unknown_count += num_lines
  end
end
puts "unknown:\t\t#{unknown_count} lines"
