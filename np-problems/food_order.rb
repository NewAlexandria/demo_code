require "logger"

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
    @scratch_order ||= []
  end

  def spend_target non_trivial:false
    if non_trivial
      single_order_search
        #|| all_order_search
        #|| order_search_includes items.sample
        #|| cached_order_search
        #|| branching_order_search
    else
      trivial_order
    end
    menu_items_from @order
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

  # Uses modulus to look for the first item 
  # that can be ordered in-multiple to make an order
  def trivial_order
    spam = items.detect {|item| target % item.values[0].to_i == 0 }
    @order = [spam.values.first] * (target/spam.values.first.to_i) if spam
  end

  def single_order_search compute_cap:14
    if (prices.size <= compute_cap)
      @order = all_order_search.sample
    else
      raise RangeError.new('','')
    end
  rescue RangeError
    logger.warn "Brute force calculation may cause machine to halt or crash. To force execution, pass a :compute_cap larger than #{prices.size}"
  end

  def all_order_search
    @all_order ||= available_orders.select {|prices| prices.sum == target }
  end

  private

  attr_accessor :scratch_order

  def available_orders
    all_permutations.reject {|prices| prices.sum > target }
  end

  def all_permutations
    (min_permutation..max_permutation).reduce([]) do |a,max|
      a += prices.repeated_permutation(max).to_a
    end
  end

  def min_permutation
    @min_perm ||= prices.index(
      prices.detect {|price| target % price == 0 }
    ) + 1
  end

  def max_permutation
    @max_perm ||= prices.reverse.index(
      prices.reverse.detect {|price| target % price == 0 }
    ) + 1
  end

  def prices
    @prices ||= items.map(&:values).flatten.map(&:to_i).sort
  end

  def menu_items_from order
    hitems = items.reduce(&:merge)
    order.map {|price| hitems.key(price.to_s) }
  end
end

