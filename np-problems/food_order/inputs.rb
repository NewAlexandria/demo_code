require 'faker'

module FoodOrderInputs

  def self.included base
    #base.send :include, InstanceMethods
    base.extend ClassMethods
  end

	module ClassMethods
    # It would be ideal to do some 'type' checking here on the input
    # We assume things are in USD$, and have two decimals of precision.
    def menu_parse filename
      raw = File.open(filename).
        readlines.map(&:strip).   		# prep lines
        reject(&:empty?).        		  # no empty ones
        map(&:gsub.with(/[$.]/,'')).	# assume $ and integer-ize
        map(&:split.with(","))  		  # give implicit key-val pairs

      items = raw[1..-1].map {|i| Hash[*i] }
      return raw[0][0].to_i, items
    end

    def menu_generator

    end

    private

    def gen_target_price max=30
      "#{rand(max)}.#{rand(99)}"
    end

    def gen_appetizer melange=3
      Faker::Flatbread.title melange

    end
  end
end

module Faker
  class Flatbread
    class << self
      def title num=3
        "#{ingredients(num)} with #{Faker::Food.dish}"
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
