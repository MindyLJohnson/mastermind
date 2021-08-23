require_relative 'user_interface.rb'

class Game
  include UserInterface

  attr_reader :board, :guess, :secret_code, :clues

  def initialize
    @board = Board.new
  end

  def play
    game_setup

    until code_cracked?
      puts player_guess_prompt
      @guess = gets.chomp.to_s.split('')

      get_clues
      board.display_board(guess, clues)
    end
  end

  def game_setup
    @secret_code = Array.new(4) {rand(1..6).to_s}
  end

  def get_clues
    @clues = []

    guess.each_index do |index|
      if guess[index] == secret_code[index]
        clues << '*'
      elsif guess.include?(secret_code[index])
        clues << '?'
      else
        clues << '_'
      end
    end

    clues.sort!
  end

  def code_cracked?
    guess.eql?(secret_code)
  end
end