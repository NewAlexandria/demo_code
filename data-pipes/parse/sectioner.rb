#!/usr/bin/sh ruby

class Sectioner

  attr_reader :sections

  def initialize filename:
    raise LoadError.new("File identifier missing") unless filename
    # validate existence
    # validate content
    @file = File.read(filename)
    @filename = filename
    @sections = []
    self.parse
    self.clean
    self.annotate
    self.pass
  end

  class << self
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
      @sections.reduce!([]) do |a, section|
        line_num = file_lines.index(section.first)
        a << [section, line_num]
      end
    end

    # TODO superclass method
    def pass target:disk
      self.respond_to?(target) ? self.send target : raise NameError
    end

    def disk
      filename_suffixed = @filename.split(/([\.])/).insert( -3,"_sections" ).join
      headers = ["section", "first_line"]
      CSV.open(filename_suffixed, 'wb') do |csv|
        csv << headers
        @sections.each {|s| csv << s }
      end
  end
end


