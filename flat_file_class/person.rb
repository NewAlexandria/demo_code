require 'time'
load 'person/klass.rb'

class Person
  extend Loaders

  DEETS = [
    :last_name, :first_name, :middle_initial,
    :gender, :birth_date,
    :favorite_color
  ]

  attr_accessor *DEETS

  def initialize opts={}
    opts.each do |k,v|
      send "#{k}=".to_sym, v
    end  if valid_init_hash?(opts)
  end

  def birth_date format='%m/%d/%Y'
    @birth_date.strftime(format)
  end

  def gender
    ['M','Male'].include?(@gender) ? 'Male' : 'Female'
  end

  private 

  def valid_init_hash? opts
     opts.is_a?(Hash)           &&
    (opts.keys - DEETS).empty?
  end
end
