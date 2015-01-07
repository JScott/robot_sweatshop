#!/usr/bin/env ruby
require 'moneta'

class FileQueue
  attr_accessor :queue
  
  def initialize(name)
    store = Moneta.new :File, dir: 'moneta'
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
