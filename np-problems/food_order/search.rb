module FoodOrderSearch

  def self.included base
    base.send :include, InstanceMethods
    #base.extend ClassMethods
  end

	module InstanceMethods

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

  end
end
