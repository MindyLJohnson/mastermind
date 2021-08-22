class Game
  attr_reader :board, :secret_code

  def initialize
    @board = Board.new
  end

  def play
    game_setup
  end

  def game_setup
    @secret_code = Array.new(4) {rand(1..6).to_s}
  end
end