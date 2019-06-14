#!/usr/bin/sh ruby

require 'csv'

class Identities

  attr_reader :ids
  attr_reader :sections, :headers, :file

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
    #pass
  end

  IDENTITIES = (
    %w{ CID EID EDT ORDER ACCOUNT Med Technician ID NAME Room Loc }.sort {|a,b| a.length <=> b.length }.reverse +
    ["Test ind", "Referred by", "Confirmed by", "Vent. rate", "PR interval", "QRS duration", "QT/QTc", "P-R-T axes"].sort {|a,b| a.length <=> b.length }.reverse
  ).freeze

  def parse
    return @sections unless @sections.empty?

    parse_fixed_fields
  end

  def clean
    #
  end

  def annotate
    annotate_linenums
    annotate_known_identities
  end

  # auto-label the data by heuristic: telemetry
  def parse_fixed_fields
    @sections << ["notes_visit", JSON.parse(@file[4][0]).join("\n"), @file[4][1]]
    @sections << ["telemetry", @file[6..10], @file[6][1]]
    [4,6,7,8,9,10].sort.reverse.each {|i| @file.delete_at i }
  end

  def annotate_linenums
    @sections = @sections + @file[1..-1].map do |s|
      JSON.parse(s.first).each_with_index.reduce([]) do |sink,(line,idx)|
        sink << [line, s.last.to_i+idx]
      end
    end.flatten(1)
  end

  def annotate_known_identities
    ident_r = Regexp.new "("+Identities::IDENTITIES.join("|")+")"
    @sections.map! do |line|
      if line.size == 3
        line
      else
        kv = line.first
          .split(ident_r)
          .reject(&:empty?)
          .map{|e| e.sub(/^:/,'').strip }
        kv << line.last
      end
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


