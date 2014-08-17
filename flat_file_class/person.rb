require 'time'
load 'person/klass.rb'

class Person
  extend Loaders

  attr_accessor :last_name, :first_name, :middle_initial,
                :gender, :birth_date,
                :favorite_color

  def initialize opts={}
    opts.each do |k,v|
      send "#{k}=".to_sym, v
    end  if valid_hashes_of_equal_length?(opts)
  end

  def birth_date format='%m/%d/%Y'
    @birth_date.strftime(format)
  end

  def gender
    ['M','Male'].include?(@gender) ? 'Male' : 'Female'
  end

  private 

  def valid_hashes_of_equal_length? opts
    opts.is_a?(Hash) || opts.map{|e| e.to_a.size}.uniq.size == 1 
  end
end
