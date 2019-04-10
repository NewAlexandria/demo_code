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

    let (:get_one) { subject.put("one", 1) }
    let (:get_two) { subject.put("two", 2) }
    it 'can lookup a first value after a second is inserted' do
      expect(subject.get("one")).to eq(1)
    end

    let (:get_three) { subject.put("three", 3) }
    it 'cannot find the subject after a third is .put' do
      expect(subject.get("two")).to raise_error
    end

    let (:get_three) { subject.put("three", 3) }
    it 'cannot find the next subject after a fourth is .put' do
      expect(subject.get("one")).to raise_error
    end

    it 'can find the correct subject index after two puts' do
      expect(subject.get("three")).to eq(3)
    end

    it 'can find the correct MRU index after two puts' do
      expect(subject.get("four")).to eq(4)
    end
  end
end

