class BinaryGap
  def solution(n)
    bin_trimmed = trim_end_zeros(n.to_s(2))
    g = groups(bin_trimmed)
    g.reject!{|e| e=='1' }.map(&:size).max || 0
  end
  alias :perform    :solution
  alias :initialize :solution

  def groups( bin )
    bin.gsub(/[1]{2,}/,'1').split(/([1])/).reject(&:empty?)
  end

  def trim_end_zeros( bin )
    ltrim = trim_left_zeros(bin)
    trim_left_zeros(ltrim.reverse).reverse
  end

  def trim_left_zeros( bin )
    start = bin.index('1')
    bin[start..-1]
  end
end
