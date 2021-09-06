require_relative 'user_interface'

class Game
  include UserInterface

  attr_reader :board, :player_mode, :clues, :guess, :secret_code,
              :possible_guesses, :remaining_guesses, :first_guess,
              :guess_scores

  POSSIBLE_GUESSES = (1111..6666).to_a.reject! do |code|
    code.to_s.split('').any?('0') || code.to_s.split('').any?('7') ||
      code.to_s.split('').any?('8') || code.to_s.split('').any?('9')
  end

  POSSIBLE_CLUES = [%w[_ _ _ _],
                    %w[? _ _ _], %w[? ? _ _], %w[? ? ? _], %w[? ? ? ?],
                    %w[* _ _ _], %w[* * _ _], %w[* * * _], %w[* * * *],
                    %w[* ? _ _], %w[* ? ? _], %w[* ? ? ?],
                    %w[* * ? _], %w[* * ? ?],
                    %w[* * * ?]].freeze

  def initialize
    @board = Board.new
    @remaining_guesses = POSSIBLE_GUESSES.collect { |code| code.to_s.split('') }
    @first_guess = true
  end

  def play
    game_setup
    crack_code
  end

  def game_setup
    puts player_mode_prompt
    @player_mode = valid_mode
    create_code
  end

  def create_code
    if player_mode == 'MAKER'
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
      @clues = board.create_clues(guess, secret_code)
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
    remaining_guesses.keep_if do |remaining_guess|
      board.create_clues(remaining_guess, guess).eql?(clues)
    end
    p board.create_clues(%w[1 2 3 4], guess).eql?(clues)
    remaining_guesses.min
  end

  def code_cracked?
    p clues
    guess.eql?(secret_code)
  end
end
