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

  describe :menu_generator do
    subject { FoodOrder.new(FoodOrder.menu_generator) }

    it 'creates a correctly structured menu' do
      expect(subject.target).to be_a(Integer)
      expect(subject.target).to be > 0
      expect(subject.items).to  be_a(Array)
      expect(subject.items.size).to be > 0
    end

    it 'creates a menu with array items' do
      expect(subject.items.map(&:respond_to?.with(:[])).reduce(&:&)).to be true
    end

    it 'creates a menu with valid prices' do
      expect(subject.items.map(&:values).flatten.map(&:to_i).reduce(&:+)).to be > 0
    end

    context 'with specified size' do
      let(:the_size) { rand(12) }
      subject { FoodOrder.new(FoodOrder.menu_generator(the_size)) }

      it 'creates a menu with specified length' do
        expect(subject.items.size).to eq(the_size)
      end
    end
  end
end

