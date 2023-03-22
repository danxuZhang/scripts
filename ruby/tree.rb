require 'pathname'

$total_line_cnt = 0
$total_words_cnt = 0

def tree(dir_path, indent_level = 0, ignore_patterns = [])
  dir_pathname = Pathname.new(dir_path)
  # ignores hidden files
  return if dir_pathname.basename.to_s.start_with?('.')

  puts "#{' ' * indent_level}#{dir_pathname.basename}"
  dir_pathname.children.each do |child|
    if child.directory?
      ignore_patterns = read_gitignore(child) if child.basename.to_s == '.git'
      tree(child.to_s, indent_level + 2, ignore_patterns)
    elsif !ignore_patterns.any? { |pattern| child.fnmatch?(pattern) }
      line_cnt = count_lines(child)
      word_cnt = count_words(child)
      $total_line_cnt += line_cnt
      $total_words_cnt += word_cnt
      puts "#{' ' * (indent_level + 2)}#{child.basename} (lines: #{line_cnt}, words:#{word_cnt})"
    end
  end
end

def read_gitignore(dir_pathname)
  ignore_patterns = []

  gitignore_pathname = dir_pathname.join('.gitignore')
  return ignore_patterns unless gitignore_pathname.file?

  File.foreach(gitignore_pathname) do |line|
    line.chomp!
    next if line.empty? || line.start_with?('#')

    if line.end_with?('/')
      ignore_patterns << "#{line}**/*"
    else
      ignore_patterns << line
    end
  end

  ignore_patterns
end

def count_lines(file_name)
  lines = File.readlines(file_name)
  lines.length
end

def count_words(file_name)
  words = File.read(file_name).split
  words.length
end

tree(ARGV[0] || Dir.pwd)
puts "\ntotal lines: #{$total_line_cnt}, total words: #{$total_words_cnt}"
