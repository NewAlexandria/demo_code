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
    subject { Person.new init_hash }

    it 'loads properly' do
      init_hash.each do |attr, val|
        expect(subject.send attr).to eq(val)
      end

      expect(subject.birth_date.class).to eq(Date)
    end

    it 'has a date format of MM/DD/YYYY' do
      expect(subject.birth_date).to eq('06/12/1978')
    end
  end

private
  
  def init_hash
    {
      last_name:'Weishaupt',
      first_name:'Adam',
      middle_initial:'C',
      gender:'M',
      birth_date:'6/12/1978',
      favorite_color:'plum'
    }
  end

end

