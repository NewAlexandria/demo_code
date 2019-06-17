#!/usr/bin/sh ruby

$LOAD_PATH << 'parse'

load 'parse/parser.rb'
require 'units_identities'
require 'csv'
require 'json'

class Sectioner < Parser

  attr_reader :sections

  HEADERS = ["section", "first_line"]

  # We should initialize with IO.foreach and #advise, if the files get large
  def initialize filename:
    super
    @file = File.read(filename)
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
      a << [section, line_num.to_i+1]
    end
  end
end
