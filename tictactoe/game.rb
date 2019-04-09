
class Game
  attr_accessor :board, :current_player
  
  def initialize opts={}
    @board = Game.reset
  end

  def move marker, pos
  end

  def self.reset
    @e = Array.new
    3.times { @e << ([nil] * 3) }
    @e
  end
end
