#!/usr/bin/sh ruby

require 'csv'

class Identities

  attr_reader :ids

  def initialize filename:
    raise LoadError.new("File identifier missing") unless filename
    # TODO validate existence
    # TODO validate content
    @file = CSV.read(filename)
    @filename = filename
    @sections = []
    @headers = ["label", "value", "line_pos"]
    parse
    clean
    annotate
    pass
  end

  IDENTITIES =
    %w{ CID EID EDT ORDER ACCOUNT Med Technician ID NAME Room Loc } +
    ["Test ind", "Referred by", "Confirmed by", "Vent. rate", "PR interval", "QRS duration", "QT/QTc", "P-R-T axes"]

  def parse
    return @sections unless @sections.empty?

    parse_fixed_fields
    annotate_linenums
    @sections.flatten!
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

  def parse_fixed_fields
    @sections << ["notes_visit", @file[4][0].join("\n"), @file[4][1]]
    @sections << ["telemetry", @file[6..10], @file[6][1]]
    [4,6,7,8,9,10].sort.reverse.each {|i| @sections.delete_at i }
  end

  def annotate_linenums
    @sections.map! do |s|
      JSON.parse(s.first).each_with_index.reduce([]) do |sink,(line,idx)|
        sink << [line, s.last.to_i+idx]
      end
    end
  end

  def filename_suffixed
    @filename.split(/([\.])/).insert( -3,file_suffix ).join
  end

  def file_suffix
    "_#{self.class.name.downcase}"
  end
end


