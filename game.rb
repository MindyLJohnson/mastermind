require_relative 'user_interface'

class Game
  include UserInterface

  attr_reader :board, :player_mode, :clues, :guess, :secret_code, :possible_solutions, :first_guess

  def initialize
    @board = Board.new
    @player_mode = 'BREAKER'
    @secret_code = []
    @possible_solutions = (1111..6666).to_a
    @first_guess = true
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
      @clues = board.create_clues(guess, secret_code, [])
      board.display_board(guess, clues)
    end
  end

  def player_crack_code
    puts player_guess_prompt
    @guess = valid_input
  end

  def computer_crack_code
    @guess = first_guess ? %w[1 1 2 2] : new_guess
    @first_guess = false
  end

  def new_guess
    possible_solutions.delete_if do |solution|
      board.create_clues(solution.to_s.split(''), guess, []).eql?(clues)
    end
    possible_solutions[1].to_s.split('')
  end

  def valid_input?(input)
    input.length == 4 && input.all? { |code| code.to_i.between?(1, 6) }
  end

  def code_cracked?
    guess.eql?(secret_code)
  end
end
