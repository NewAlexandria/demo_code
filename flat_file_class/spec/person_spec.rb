load 'person.rb'

describe :person do
  context 'class' do
    subject { Person }
    let(:test_source) { Loaders::SOURCES.first }

    it 'has valid sources' do
      # arguably, we might define a Source class, with validations
      expect(test_source.is_a?(Hash)).to eq(true)
      expect(test_source.keys.sort).to   eq([:name,:delim,:headers].sort)
    end

    describe :load_source do
      subject { Person.load_source test_source }

      it 'has the correct number of elements' do
        expect(subject.size).to eq(File.readlines("sources/#{test_source[:name]}").size)
      end

      it 'has the correct kind of elements' do
        expect(subject.map(&:class).uniq.size).to eq(1)
        expect(subject.map(&:class).uniq).to      eq([Person])
      end

      it "loaded headers correctly for an object" do
        test_source.fetch(:headers, []).each do |header|
          expect(subject.shuffle.first.respond_to? header.to_sym ).to eq(true)
        end
      end

    end

    describe :all do
      subject { Person.all }

        let(:total_records) do
          Loaders::SOURCES.reduce(0) do |total, source|
            total += File.readlines("sources/#{source[:name]}").size
          end
        end

      it 'is composed of all source file rows' do
        expect(subject.size).to eq(total_records)
      end
    end

  end

  context 'instance' do
    subject { Person.new init_hash }

    it 'loads properly' do
      init_hash.each do |attr, val|
        expect(subject.send attr).not_to be_nil
      end

      expect(subject.birth_date.class).to eq(String)
      expect(subject.birth_date.match(/[0-9]{2}\/[0-9]{2}\/[0-9]{4}/)).not_to be_nil
    end

    it 'has a date format of MM/DD/YYYY' do
      expect(subject.birth_date).to eq('06/12/1978')
    end

    it 'has expands gender to a full word' do
      expect(subject.gender).to eq('Male')
    end
  end

private # fixtures

  def init_hash
    {
      last_name:'Weishaupt',
      first_name:'Adam',
      middle_initial:'C',
      gender:'M',
      birth_date:Date.strptime('6/12/1978','%m/%d/%Y'),
      favorite_color:'plum'
    }
  end

end

