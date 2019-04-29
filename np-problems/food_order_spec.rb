load 'food_order.rb'

describe :food_order do
  subject { FoodOrder.new('menu.txt') }

  context 'for a spend_target with a' do
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
    describe :trivial_order do
      before(:each) do
        subject.spend_target non_trivial:true
      end

      it 'builds an order' do
        expect(subject.order).not_to be_nil
      end
    end
  end

  context 'can initialize' do

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

