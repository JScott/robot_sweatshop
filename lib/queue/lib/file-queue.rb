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

  def self.mirroring
    @store[MIRRORING_ENABLED]
  end

  def enqueue(item)
    @store[@mirror_name] = @store[@mirror_name].push item if @store[MIRRORING_ENABLED]
    @store[@name] = @store[@name].push item
  end
  
  def dequeue
    return '' if @store[@name].empty?
    item = @store[@name].first
    @store[@name] = @store[@name][1..-1]
    item
  end

  def size
    @store[@name].size
  end

  def clear
    @store[@mirror_name] = []
    @store[@name] = []
  end
end
