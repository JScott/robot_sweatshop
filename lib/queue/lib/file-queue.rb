#!/usr/bin/env ruby
require 'moneta'

class FileQueue
  attr_reader :watched_queues

  MONETA_DIR = File.expand_path "#{__dir__}/moneta"
  @@store = Moneta.new :File, dir: MONETA_DIR

  def initialize(name)
    @name = name
    @mirror_name = "mirror-#{name}"
    @@store[@name] ||= []
    @@store[@mirror_name] ||= []
  end

  def self.watched_queues
    %w(raw-payload parsed-payload jobs testing)
  end

  def self.clear_all
    watched_queues.each do |queue|
      @@store[queue] = []
      @@store["mirror-#{queue}"] = []
      p @@store[queue], @@store["mirror-#{queue}"]
    end
  end

  def enqueue(item)
    @@store[@name] = @@store[@name].push item
    @@store[@mirror_name] = @@store[@mirror_name].push item
  end
  
  def dequeue
    return '' if @@store[@name].empty?
    item = @@store[@name].first
    @@store[@name] = @@store[@name][1..-1]
    item
  end

  def size
    @@store[@name].size
  end

  def clear
    @@store[@mirror_name] = []
    @@store[@name] = []
  end

  def inspect
    @@store[@name].inspect
  end
end
