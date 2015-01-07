#!/usr/bin/env ruby
require 'moneta'

class FileQueue
  attr_accessor :queue
  
  MONETA_DIR = File.expand_path "#{__dir__}/moneta"
  
  def initialize(name)
    store = Moneta.new :File, dir: MONETA_DIR
    store[name] = []
    @queue = store[name]
  end
  
  def push(item)
    @queue.push item
  end
  
  def pop
    @queue.pop
  end

  def size
    @queue.size
  end
end
