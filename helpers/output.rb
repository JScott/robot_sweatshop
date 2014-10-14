require 'logger'
require 'colorize'

def throw_error(string)
  throw :error, "! #{string}".red
end

def puts_info(string)
  $stdout.puts "> #{string}".light_blue
  $stdout.flush
end

def puts_script(string)
  $stdout.puts string
  $stdout.flush
end
