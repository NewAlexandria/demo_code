load 'food_order.rb'

describe :food_order do
  context 'for a spend_target with a' do
    subject { FoodOrder.new('menu.txt') }

    describe :trivial_order do
      before(:each) do
        subject.spend_target 
      end

      it 'builds an order' do
        expect(subject.order).not_to be_nil
      end
    end
  end

  context 'for a non-trivial spend_target' do
  end

  context 'can initialize' do
    subject { FoodOrder.new('menu.txt') }

    describe :menu_parse do
      it 'and translate a file' do
        expect(subject.items).to  be_a(Array)
        expect(subject.target).to be_a(Integer)
      end

      it 'gives no zero-dollar prices' do
        expect(
          subject.items.
          map(&:values).flatten.
          map(&:to_i).detect(&:zero?)
        ).to be_nil
      end
    end
  end
end


=begin handy rspec examples

  context 'when initialized to 2' do
    subject { LRUCache.new(2) }

    context 'with two values inserted' do
      before(:each) do
        subject.put("one", 1)
        subject.put("two", 2)
      end

      it 'can lookup a first value after a second is inserted' do 
        expect(subject.get("one")).to eq(1)
      end
    end

    context 'with three values inserted' do
      before(:each) do
        subject.put("one", 1)
        subject.put("two", 2)
        subject.put("three", 3)
      end

      it 'cannot find the subject after a third is .put' do
        expect(subject.get("one")).to be_nil
      end
    end

    context 'with four values inserted' do
      before(:each) do
        subject.put("one", 1)
        subject.put("two", 2)
        subject.put("three", 3)
        subject.put("four", 4)
      end

      it 'cannot find the next subject after a fourth is .put' do
        expect(subject.get("one")).to be_nil
      end

      it 'can find the correct subject index after two puts' do
        expect(subject.get("three")).to eq(3)
      end

      it 'can find the correct MRU index after two puts' do
        expect(subject.get("four")).to eq(4)
      end
    end

  end
end
=end

