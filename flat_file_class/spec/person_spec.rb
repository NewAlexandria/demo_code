require '../person'

describe :person do
  context 'class actions' do
    subject { Person }
    let(:test_source) { Person::SOURCES.first }

    it 'has valid sources' do
      # arguably, we might define a Source class, with validations
      expect(test_source.is_a?(Hash)).to be_true
      expect(test_source.keys.sort).to   eq([:name,:delim,:headers].sort)
    end

    describe :load_source do
      subject { Person.load_source test_source }

      it 'has the correct number of elements' do
        expect(subject.size).to eq(File.readlines("../sources/#{test_source[:name]}").size)
      end

      it 'has the correct kind of elements' do
        expect(subject.map(&:class).uniq.size).to eq(1)
        expect(subject.map(&:class).uniq).to      eq(Person)
      end

      test_source.fetch(:headers, []).each do |header|
        it "loaded '#{header}' correctly for an object" do
          expect(subject.shuffle.first.respond_to? header.to_sym ).to be_true
        end
      end

    end

    describe :all do
      subject { Person.all }

      it 'is composed of all source file rows' do
        let(:total_records) do
          Person::SOURCES.sum(0) do |total, source|
            total += File.readlines("../sources/#{source[:name]}").size
          end
        end
              
        expect(subject.size).to eq(total_records)
      end
    end

  end

  context 'instance, ' do

  end

end
