require "logger"
load "food_order/inputs.rb"
load "food_order/search.rb"
load "food_order/profiling.rb"

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

  include FoodOrderInputs
  include FoodOrderSearch
  include FoodOrderProfiling

  # precompute iteration bounds with file init
  def initialize filename
    @target, @items = self.class.menu_parse filename
    @cap = max_safe_permutations
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

  private

  attr_accessor :scratch_order

  def prices
    @prices ||= items.map(&:values).flatten.map(&:to_i).sort
  end

  def menu_items_from order
    hitems = items.reduce(&:merge)
    order.map {|price| hitems.key(price.to_s) }
  end
  
  def logger
    @logger ||= Logger.new(STDOUT)
    @logger.level = Logger::WARN
    @logger
  end
end

