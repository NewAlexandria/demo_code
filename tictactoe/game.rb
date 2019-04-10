
class Game
  attr_accessor :board, :active_player
  
  def initialize opts={}
    @board = Game.reset
    @active_player = 'x'
  end

  def move marker, pos
    raise if !pos.is_a?(Array) && pos.size == 2
  end

  def self.reset
    @e = Array.new
    3.times { @e << ([nil] * 3) }
    @e
  end
end
