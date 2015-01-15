#!/usr/bin/env ruby
require 'moneta'

class FileQueue
  attr_accessor :store

  MONETA_DIR = File.expand_path "#{__dir__}/moneta"
  MIRRORING_ENABLED = 'enable-mirroring'
  
  def initialize(name)
    @name = name
    @mirror_name = "mirror-#{name}"
    @store ||= Moneta.new :File, dir: MONETA_DIR
    @store[name] ||= []
  end
  
  def self.mirroring=(boolean)
    @store ||= Moneta.new :File, dir: MONETA_DIR
    @store[MIRRORING_ENABLED] = boolean
  end

  def push(item)
    @store[@mirror_name] = @store[@mirror_name].push item if @store[MIRRORING_ENABLED]
    @store[@name] = @store[@name].push item
  end
  
  def pop(from: :store)
    name =  from == :mirror ? @mirror_name : @name
    item = @store[name].first
    @store[name] = @store[name][1..-1]
    item
  end

  def size
    # TODO: sometimes calling nil.size when you push empty into the queue ...
    @store[@name].size
  end

  def clear
    @store[@name] = []
  end
end
