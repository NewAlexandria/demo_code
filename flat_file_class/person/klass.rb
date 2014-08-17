module Loaders
  SOURCES = [
    {name:'comma_delimited.txt', delim:',',
     headers:[:first_name, :last_name, :gender, :favorite_color, :birth_date]},
    {name:'pipe_delimited.txt',  delim:'|',
     headers:[:first_name, :last_name, :middle_initial, :gender, :favorite_color, :birth_date]},
    {name:'space_delimited.txt', delim:' ',
     headers:[:first_name, :last_name, :middle_initial, :gender, :birth_date, :favorite_color]}
  ]

  def all source_list=nil
    sources = SOURCES if !source_list.is_a?(Hash) || source_list.any?
    sources.reduce([]) do |all_records,source_info|
      all_records += load_source(source_info)
    end
  end

  def load_source source
    File.readlines("sources/#{source[:name]}").
         map{|line|  Person.new hash_from(source, line)  }
  end

private

  def hash_from source, line
    Hash[source[:headers].zip(line.split(source[:delim]).map(&:strip))].tap do |h|
      h[:birth_date] = Date.strptime( h[:birth_date].to_s.gsub('-','/'), '%m/%d/%Y' )
    end
  end

end
