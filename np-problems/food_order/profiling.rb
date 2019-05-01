require 'memory_profiler'

module FoodOrderProfiling

  def self.included base
    base.send :include, InstanceMethods
    #base.extend ClassMethods
  end

	module InstanceMethods
    
    # Profile each permutation cap until we project underperformance
    def max_safe_permutations
      (min_permutation..max_permutation).detect do |itr|
        report = MemoryProfiler.report do
          all_permutations minp:min_permutation, maxp:itr
        end
        #
      end
    end

  end
end
