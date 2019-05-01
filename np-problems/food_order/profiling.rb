require 'memory_profiler'

module FoodOrderProfiling

  def self.included base
    base.send :include, InstanceMethods
    #base.extend ClassMethods
  end

  MEM_GC_LIMIT = GC.stat[:malloc_increase_bytes_limit]

	module InstanceMethods

    # Profile each permutation cap until we project underperformance
    def max_safe_permutations
      mem_uses = []
      (min_permutation..max_permutation).detect do |itr|
        report = MemoryProfiler.report do
          all_permutations minp:min_permutation, maxp:itr
        end
        mem_uses << mem_from(report)
        mem_from(report) >= MEM_GC_LIMIT
      end
      logger.info "Mem counts for #{min_permutation} to #{max_permutation} are #{mem_uses.inspect}"

      while (mem_itr_step * mem_uses.last) < MEM_GC_LIMIT do
        mem_uses << (mem_itr_step * mem_uses.last)
      end

      mem_uses.count
    end

    private

    # Size of memory allocations
    # for this codebase, the useful type is Array
    def mem_from report, allocated_kind="Array"
      report.allocated_memory_by_class
        .find {|e| e[:data] == allocated_kind }[:count]
    end

    # calculate the delta series for memory allocations,
    # and then return the average
    def mem_itr_step mem_uses
      logger.warn "memory step profiling unlikely accurate with #{mem_uses.size} data" if mem_uses.size <= 3
      (0..mem_uses.length-2)
        .map {|i| mem_uses[i+1] / mem_uses[i].to_f }
        .tap {|arr| @step_set_size = arr.size }
        .sum.fdiv(@step_set_size).round(3)
    end

  end
end
