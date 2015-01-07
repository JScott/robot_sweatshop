#!/usr/bin/env ruby
require 'moneta'
require 'json'

class FileQueue
  attr_accessor :store

  MONETA_DIR = File.expand_path "#{__dir__}/moneta"
  
  def initialize(name)
    @name = name
    @store ||= Moneta.new :File, dir: MONETA_DIR
    @store[name] ||= '[]'
  end

  def push(item)
    array = JSON.parse @store[@name]
    array.push item
    @store[@name] = JSON.generate array
  end
  
  def pop
    array = JSON.parse @store[@name]
    value = array.pop
    @store[@name] = array
    value
  end

  def size
    @store[@name].size
  end

  def close
    @store.close
  end
end
