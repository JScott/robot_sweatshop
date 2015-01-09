#!/usr/bin/env ruby
require 'moneta'

class FileQueue
  attr_accessor :store

  MONETA_DIR = File.expand_path "#{__dir__}/moneta"
  
  def initialize(name)
    @name = name
    @store ||= Moneta.new :File, dir: MONETA_DIR
    @store[name] ||= []
  end

  def push(item)
    @store[@name].push item
  end
  
  def pop
    item = @store[@name].first
    @store[@name] = @store[@name][1..-1]
    item
  end

  def size
    @store[@name].size
  end

  def clear
    @store[@name] = []
  end
end
