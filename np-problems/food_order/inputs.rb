require 'faker'

module FoodOrderInputs

  def self.included base
    #base.send :include, InstanceMethods
    base.extend ClassMethods
  end

	module ClassMethods
    # It would be ideal to do some 'type' checking here on the input
    # We assume things are in USD$, and have two decimals of precision.
    def menu_parse menu_source
      raw = case menu_source
            when String then read_menu menu_source
            when Array  then menu_source
            end
      target = raw.shift[0].to_s.tr('.','').to_i
      items  = price_in_pennies(raw).map {|i| Hash[*i] }
      return target, items
    end

    def read_menu filename
      File.open(filename).
        readlines.map(&:strip).      # prep lines
        reject(&:empty?).            # no empty ones
        map(&:gsub.with(/[$.]/,'')). # assume $ and integer-ize
        map(&:split.with(","))       # give implicit key-val pairs
    end

    def menu_generator size=7
			target = gen_target_price
      items  = []
      size.times do
        items << [ gen_appetizer, (rand * target).round(2) ]
      end
      [[target],*items]
    end

    private

    def gen_target_price max=30
      "#{rand((max/3)..max)}.#{rand(99)}".to_f
    end

    def gen_appetizer melange=2
      Faker::Flatbread.title melange
    end

    def price_in_pennies items=[]
      items.map do
        |item,price| [item, price.to_s.gsub('.','')]
      end if items.all? {|e| e.size==2 }
    end
  end
end

module Faker
  class Flatbread
    class << self
      def title num=3
        "#{ingredients(num)} with #{Faker::Food.vegetables}"
      end

      def ingredients num, with_spice:true
      end

      def ingredients melange=3
        (1..(rand(melange)+1))
          .map{rand > 0.5 ? Faker::Food.ingredient : Faker::Food.vegetables}
          .shuffle
          .tap {|arr| arr[-1] = "#{Faker::Food.spice} #{arr.last}" }
          .shuffle.join(' and ')
      end
    end
  end
end
