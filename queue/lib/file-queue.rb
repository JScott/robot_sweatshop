#!/usr/bin/env ruby
require 'moneta'

class FileQueue
  attr_accessor :store

  MONETA_DIR = File.expand_path "#{__dir__}/moneta"
  
  def initialize(name)
    @name = name
    @store ||= Moneta.new :File, dir: MONETA_DIR
  end

  def push(item)
    @store[@name] = @store[@name].push item
  end
  
  def pop
    value = @store[@name].last
    @store[@name] = @store[@name][0...-1]
    value
  end

  def size
    @store[@name].size
  end

  def close
    @store.close
  end
end
