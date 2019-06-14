#!/usr/bin/sh ruby

require 'csv'

class Sectioner

  attr_reader :sections

  def initialize filename:
    raise LoadError.new("File identifier missing") unless filename
    # validate existence
    # validate content
    @file = File.read(filename)
    @filename = filename
    @sections = []
    @headers = ["section", "first_line"]
    self.parse
    self.clean
    self.annotate
    self.pass
  end

    def parse
      return @sections unless @sections.empty?

      parser = "\n\n"
      @sections = @file.split(parser)
    end

    def clean
      @sections.map! {|s| s.split("\n").map {|line| line.strip } }
    end

    def annotate
      file_lines = @file.split("\n")
      @sections = @sections.reduce([]) do |a, section|
        line_num = file_lines.index(section.first)
        a << [section, line_num]
      end
    end

    # TODO superclass method
    # TODO implement method-pass target
    def pass target:disk
      self.respond_to?(target) ? self.send(target) : raise(NameError)
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


