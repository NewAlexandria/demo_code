class Symbol
  def with(*args, &block)
    lambda { |object| object.public_send(self, *args, &block) }
  end

  def call(*args, &block)
    ->(caller, *rest) { caller.send(self, *rest, *args, &block) }
  end
end

class FoodOrder
  attr_accessor :items
  attr_reader   :target, :order

  def initialize filename
    @target, @items = self.class.menu_parse filename
  end

  def spend_target non_trivial:false
    if non_trivial
      first_order_search
        #|| all_order_search
        #|| order_search_includes items.sample
        #|| cached_order_search
        #|| branching_order_search
    else
      trivial_order
    end
    @order
  end

  # It would be ideal to do some 'type' checking here on the input
  # We assume things are in USD$, and have two decimals of precision.
  def self.menu_parse filename
    raw = File.open(filename).
      readlines.map(&:strip).   		# prep lines
      reject(&:empty?).        		  # no empty ones
      map(&:gsub.with(/[$.]/,'')).	# assume $ and integer-ize
      map(&:split.with(","))  		  # give implicit key-val pairs

		items = raw[1..-1].map {|i| Hash[*i] }
    return raw[0][0].to_i, items
  end

  private

  # Uses modulus to look for the first item 
  # that can be ordered in-multiple to make an order
  def trivial_order
    spam = items.detect {|item| target % item.values[0].to_i == 0 }
    @order = [spam.keys.first] * (target/spam.values.first.to_i) if spam
  end

  def first_order_search
  end
end

