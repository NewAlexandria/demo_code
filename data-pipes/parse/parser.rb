#!/usr/bin/sh ruby

require 'csv'

class Parser

  def initialize
    raise 'this method should be overriden and return the db name'
  end

  # TODO for a superclass method
  def pass save_target=:disk
    send save_target
    puts "saved to #{save_target}"
  end

  def disk
    CSV.open(filename_suffixed+'.csv', 'wb') do |csv|
      csv << @headers
      @sections.each {|s| csv << s }
    end
  end

  def filename_suffixed
    @filename.split(/([\.])/).first.concat file_suffix
  end

  def file_suffix
    "_#{self.class.name.downcase}"
  end
end
