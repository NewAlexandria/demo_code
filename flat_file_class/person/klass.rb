module Loaders
  SOURCES = [
    {name:'comma_delimited.txt', delim:',',
     headers:[:last_name, :first_name, :gender, :favorite_color, :birth_date]},
    {name:'pipe_delimited.txt',  delim:'|',
     headers:[:last_name, :first_name, :middle_initial, :gender, :favorite_color, :birth_date]},
    {name:'space_delimited.txt', delim:' ',
     headers:[:last_name, :first_name, :middle_initial, :gender, :birth_date, :favorite_color]}
  ]

  def all opts={}
    # multi-stage logic to determine if memoized cache can be used
    if sources_valid?(opts[:source_list])
      if @last_custom_list != opts[:source_list]
        @last_custom_list = opts[:source_list]
        @all = load_sources(opts[:source_list])
      end
    else
      clear_cache if @last_custom_list
      @last_custom_list = nil
      @all ||= load_sources(SOURCES)
    end
  end


  def load_sources source_list
    source_list.reduce([]) do |all_records,source_info|
      all_records += load_source(source_info)
    end
  end

  def load_source source
    File.readlines("sources/#{source[:name]}").
         map{|line|  Person.new hash_from(source, line)  }
  end

  def clear_cache
    @all=nil
  end

private

  # format fields, then zip with headers
  def hash_from source, line
    line_elements = line.split(source[:delim]).map(&:strip)
    Hash[source[:headers].zip(line_elements)].tap do |h|
      h[:birth_date] = Date.strptime( h[:birth_date].to_s.gsub('-','/'), '%m/%d/%Y' )
    end
  end

  def sources_valid? source_list
    source_list.is_a?(Hash) && source_list.any? 
  end

end
