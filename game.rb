require_relative 'user_interface.rb'

class Game
  include UserInterface

  def initialize
    @board = Board.new
  end

  def play
    game_setup

    puts player_guess_prompt
    guess = gets.chomp
    board.display_board(guess)
  end

  def game_setup
    @secret_code = Array.new(4) {rand(1..6).to_s}
  end
end