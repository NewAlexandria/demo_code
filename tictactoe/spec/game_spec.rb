load 'game.rb'

describe :game do
  context 'before playing' do
    subject { Game.new }
    let (:x3_board) {
      [
        [nil,nil,nil],
        [nil,nil,nil],
        [nil,nil,nil]
      ]
    }

    it 'has a board of 3x3 size' do
      expect( subject.board ).to be_kind_of(Array)
    end
    it 'has an empty board' do
      expect(subject.board).to eq(x3_board)
    end

    it 'can record the active player' do
      expect(subject.active_player).to exist
    end

    it 'can make a move' do
      expect(subject).to respond_to(:move)
      expect(subject.move('x',[1,1])).to be_truthy
    end
  end
end
