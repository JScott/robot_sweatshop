require 'fileutils'
require 'robot_sweatshop/config'

module CLI
  def self.notify(type = :success, string)
    color = case type
    when :success
      :green
    when :failure
      :red
    when :warning
      :yellow
    when :info
      :light_blue
    else
      ''
    end
    puts "[#{type.to_s.capitalize.colorize(color)}] #{string}"
  end

  def self.edit(file)
    editor = ENV['EDITOR']
    if editor
      CLI.notify :info, "Manually editing file '#{file}'"
      system editor, file
    else
      CLI.notify :warning, "No editor specified in $EDITOR environment variable"
      CLI.notify :info, "Displaying file contents instead"
      system 'cat', file
    end
  end

  def self.create(file, with_contents: '')
    file = File.expand_path file
    if File.file?(file)
      CLI.notify :info, "'#{file}' already exists"
    else
      FileUtils.mkdir_p File.dirname(file)
      File.write file, with_contents
      CLI.notify :success, "Created new file '#{file}'"
    end
  end
end
