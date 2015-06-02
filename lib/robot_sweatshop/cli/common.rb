require 'fileutils'
require 'robot_sweatshop/config'
require 'terminal-announce'

module CLI
  def self.edit(file)
    editor = ENV['EDITOR']
    if editor
      Announce.info "Manually editing file '#{file}'"
      system editor, file
    else
      Announce.warning "No editor specified in $EDITOR environment variable"
      Announce.info "Displaying file contents instead"
      system 'cat', file
    end
  end

  def self.create(file, with_contents: '')
    file = File.expand_path file
    if File.file?(file)
    Announce.info "'#{file}' already exists"
    else
      FileUtils.mkdir_p File.dirname(file)
      File.write file, with_contents
      Announce.success "Created new file '#{file}'"
    end
  end
end
