#!/usr/bin/sh ruby

class Sectioner

  attr_reader :sections

  def initialize filename:
    raise InputError.new("File identifier missing") unless filename
    # validate existence
    # validate content
    @file = File.read(filename)
    @sections = []
    self.parse
  end

  def self.parse
    return @sections unless @sections.empty?

    @sections = @file.split("\n\n")    
  end
end


