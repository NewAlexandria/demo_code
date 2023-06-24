module RubyMaths
  class FindGap
    def initialize(debug: false)
      @debug = debug
    end

    def solution(a)
      return unless (a.is_a?(Array)) \
        && (a.map{|e| e.class }.uniq.size > 1) \
        && (a.first.class != Integer)

      aa = a.sort.reject(&:negative?) ; aa.size
      aa.unshift(0) if aa.size.zero?
      target = nil
      if target = common_edge_case?(aa)
        return target
      else
        aa.each.with_index do |e, idx|
          puts( 'e', e) && puts ('idx', idx) if @debug

          unless aa[idx+1]
            target = e+1
            break
          end
          if e + 1 == aa[idx+1] or e == aa[idx+1]
            next
          else
            target = e + 1
            break
          end
        end
      end

      target
    end

    def common_edge_case?(aa)
      target = nil

      if aa.size == aa[-1]
        target = aa[-1] + 1
      end

      target
    end

    def simulate

    end

    def test

    end
  end
end
