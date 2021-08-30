require_relative 'user_interface'

class Game
  include UserInterface

  attr_reader :board, :player_mode, :clues, :guess, :secret_code

  def initialize
    @board = Board.new
    @player_mode = 'BREAKER'
    @secret_code = []
  end

  def play
    game_setup
    crack_code
  end

  def game_setup
    puts player_mode_prompt
    @player_mode = gets.chomp
    create_code
  end

  def create_code
    if player_mode.upcase == 'MAKER'
      puts secret_code_prompt
      p @secret_code = valid_input
    else
      p @secret_code = Array.new(4) { rand(1..6).to_s }
    end
  end

  def crack_code
    until code_cracked?
      if player_mode == 'BREAKER'
        player_crack_code
      else
        computer_crack_code
      end
      @clues = []
      create_clues
      board.display_board(guess, clues)
    end
  end

  def player_crack_code
    puts player_guess_prompt
    @guess = valid_input
  end

  def computer_crack_code
    
    @guess = Array.new(4) { rand(1..6).to_s }
  end

  def create_clues
    guess.each_index do |index|
      clues << if guess[index] == secret_code[index]
                 '*'
               elsif guess.include?(secret_code[index])
                 '?'
               else
                 '_'
               end
    end
    clues.sort!
  end

  def valid_input?(input)
    input.length == 4 && input.all? { |code| code.to_i.between?(1, 6) }
  end

  def code_cracked?
    guess.eql?(secret_code)
  end
end
