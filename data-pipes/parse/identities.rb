#!/usr/bin/sh ruby

$LOAD_PATH << 'parse'

load 'parse/parser.rb'
require 'units_identities'
require 'csv'
require 'json'

class Identities < Parser

  include UnitsIdentities

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
    annotate
    clean
    pass
  end

  def parse
    return @sections unless @sections.empty?

    parse_fixed_fields
  end

  def clean
    mark_unlabeled_fields
    split_tab_conjoins
    split_conjoined_units
    clean_unit_fields
    clean_dates
  end

  def annotate
    annotate_linenums
    annotate_known_identities
  end

  def clean_dates
    @sections.map! do |elem|
      if elem[1].is_a?(String) && elem[1].match(DATE_INPUT_FORMAT)
        elem.tap {|e| e[1] = DateTime.parse(elem[1]).strftime(DATE_OUTPUT_FORMAT) }
      else
        elem
      end
    end
  end

  def mark_unlabeled_fields
    @sections.map! do |elem|
      elem.size == 2 ? elem.unshift(nil) : elem
    end
  end

  # if this is a field with one unit, replace tabs, etc.
  def clean_unit_fields
    @sections = @sections.reduce([]) do |a,elem|
      if elem[1].is_a?(String) && elem[1].scan(units_r).size == 1
        a << elem.tap {|e| e[1] = e[1].gsub(/\s/,' ') }
      else
        a << elem
      end
    end
  end

  def split_tab_conjoins
    @sections = @sections.reduce([]) do |a,elem|
      if elem[1].is_a?(String) && elem[1].match(/[\t]{2,}/)
        elems = elem[1].split(/[\t]+/).map {|e| [elem.first, e, elem.last] }
        a.concat elems
      else
        a << elem
      end
    end
  end

  def split_conjoined_units
    @sections = @sections.reduce([]) do |a,elem|
      if elem[1].is_a?(String) && elem[1].scan(units_r).size == 2
        elems = elem[1].split.map {|e| [elem.first, e, elem.last] }
        a.concat elems
      else
        a << elem
      end
    end
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

end
