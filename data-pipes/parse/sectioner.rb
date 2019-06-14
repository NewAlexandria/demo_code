#!/usr/bin/sh ruby

require 'csv'

class Sectioner

  attr_reader :sections

  def initialize filename:
    raise LoadError.new("File identifier missing") unless filename
    # TODO validate existence
    # TODO validate content
    @file = File.read(filename)
    @filename = filename
    @sections = []
    @headers = ["section", "first_line"]
    parse
    clean
    annotate
    pass
  end

  def parse
    return @sections unless @sections.empty?

    parser = "\n\n"
    @sections = @file.split(parser)
  end

  def clean
    @sections.map! do |s|
      s.split("\n")
        .map {|line| line.strip }
        .reject(&:empty?)
    end
  end

  # TODO cannot handle multiple matching first-line-of-block
  def annotate
    file_lines = @file.split("\n")
    @sections = @sections.reduce([]) do |a, section|
      line_num = file_lines.index(section.first)
      a << [section, line_num+1]
    end
  end

  # TODO for a superclass method
  def pass save_target=:disk
    send save_target
    puts "saved to #{save_target}"
  end

  def disk
    CSV.open(filename_suffixed, 'wb') do |csv|
      csv << @headers
      @sections.each {|s| csv << s }
    end
  end

  def filename_suffixed
    @filename.split(/([\.])/).insert( -3,file_suffix ).join
  end

  def file_suffix
    "_#{self.class.name.downcase}"
  end
end


