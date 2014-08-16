class Person
  require 'person/klass'
  require 'time'

  attr_accessor :last_name, :first_name, :middle_initial,
                :gender, :birth_date,
                :favorite_color

  def initialize opts={}
    opts.each do |k,v|
      send k.to_sym, v
    end  if opts.is_a?(Hash) || opts.map{|e| e.to_a.size}.uniq.size == 1
  end

  def birth_date
    birth_date.strftime("%m/%d/%Y")
  end

end
