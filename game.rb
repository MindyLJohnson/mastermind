require_relative 'board'
require_relative 'user_interface'

class Game
  include UserInterface
  include Board

  attr_reader :player_mode, :maker, :breaker, :guess, :clues

  def initialize
    @player_mode = 'BREAKER'
    @guess = []
    @clues = []
    @secret_code = []
  end

  def play
    game_mode
    @secret_code = maker.create_code
    crack_code
    puts 'CODE CRACKED!!'
  end

  def game_mode
    puts player_mode_prompt
    @player_mode = valid_mode
    if player_mode == 'MAKER'
      @maker = HumanPlayer.new
      @breaker = ComputerPlayer.new
    else
      @maker = ComputerPlayer.new
      @breaker = HumanPlayer.new
    end
  end

  def crack_code
    until code_cracked?
      @guess = breaker.new_guess
      @clues = breaker.new_clues(guess, @secret_code)
      display_board(guess, clues)
    end
  end

  def code_cracked?
    guess.eql?(@secret_code)
  end
end
