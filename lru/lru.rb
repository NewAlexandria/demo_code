class LRUCache
  attr_accessor :xl, :hm
  attr_reader :max
    
=begin
    :type capacity: Integer
=end
    def initialize(capacity)
      @max = capacity
      @xl = Array.new(@max)
      @hm = Hash.new
    end


=begin
    :type key: Integer
    :rtype: Integer
=end
    def get(key)
      obj_ref = @hm[key]
      @xl.delete(obj_ref)
      @xl.unshift(obj_ref)
      obj_ref[:value]
    end


=begin
    :type key: Integer
    :type value: Integer
    :rtype: Void
=end
    def put(key, value)
      new_val_obj = { key: key, value: value }
      @hm[key] = new_val_obj
      @xl.unshift(new_val_obj)
      if @xl.size > max
        e = @xl.delete(@xl.last)
        puts e.class.name.to_s
        hm.delete e[:key] if e
      end
    end

end

describe :lrucache do
  context 'when initialized to 2' do
    subject { LRUCache.new(2) }

    it 'can lookup a first value after a second is inserted' do
    end

    it 'cannot find the LRU after a third is .put' do
    end

    it 'cannot find the next LRU after a fourth is .put' do
    end

    it 'can find the correct LRU index after two puts' do
    end

    it 'can find the correct MRU index after two puts' do
    end
  end
end

