require 'colorize'

def throw_error(string)
  throw :error, "! #{string}".red
end

def puts_info(string)
  puts "> #{string}".light_blue
end

def puts_script(string)
  puts string
end
