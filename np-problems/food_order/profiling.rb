require 'memory_profiler'
require 'vmstat'

module FoodOrderProfiling

  def self.included base
    base.send :include, InstanceMethods
    #base.extend ClassMethods
  end

  MEM_GC_LIMIT = GC.stat[:malloc_increase_bytes_limit]

	module InstanceMethods

    attr_accessor :mem_uses

    # Profile each permutation cap until we project underperformance
    # stop at the GC limit, to ensure a consistent memory state
    def max_safe_permutations
      if @max_safe_permutations
        return @max_safe_permutations
      else
        memory_step_profile

        while (mem_itr_step * mem_uses.last) < mem_available_limit do
          mem_uses << (mem_itr_step * mem_uses.last)
        end

        @max_safe_permutations = mem_uses.count
      end
    end

    private

    # Run through permutations, recording the memory allocation for each
    def memory_step_profile
      return @mem_uses if @mem_uses && !@mem_uses.empty?
      @mem_uses = []
      (min_permutation..max_permutation).detect do |itr|
        report = MemoryProfiler.report do
          all_permutations minp:min_permutation, maxp:itr
        end
        @mem_uses << mem_from(report)
        mem_from(report) >= MEM_GC_LIMIT
      end

      logger.info "Mem counts for #{min_permutation} to #{max_permutation} are #{@mem_uses.inspect}"
      @mem_uses
    end

    # Size of memory allocations
    # for this codebase, the useful type is Array
    def mem_from report, allocated_kind="Array"
      report.allocated_memory_by_class
        .find {|e| e[:data] == allocated_kind }[:count]
    end

    # calculate the delta series for memory allocations,
    # and then return the average
    def mem_itr_step
      logger.warn "memory step profiling unlikely accurate with #{mem_uses.size} data" if mem_uses.size <= 3
      (0..mem_uses.length-2)
        .map {|i| mem_uses[i+1] / mem_uses[i].to_f }
        .tap {|arr| @step_set_size = arr.size }
        .sum.fdiv(@step_set_size).round(3)
    end

    def mem_free_limit
      Vmstat.snapshot.memory.free_bytes
    end
    
    def mem_available_limit
      Vmstat.snapshot.memory.inactive_bytes + mem_free_limit
    end
  end
end
