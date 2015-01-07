#!/usr/bin/env ruby
require 'moneta'

class FileQueue
  attr_accessor :store, :queue

  MONETA_DIR = File.expand_path "#{__dir__}/moneta"
  
  def initialize(name)
    @name = name
    @store ||= Moneta.new :File, dir: MONETA_DIR
    @queue = @store[name] ||= []
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

  def close
    @store.close
  end
end
