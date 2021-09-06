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
    @possible_guesses = remaining_guesses.clone
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
    possible_guesses.delete(guess)
  end

  def new_guess
    reduce_guesses
    next_guess
    remaining_guesses.min
  end

  def reduce_guesses
    remaining_guesses.keep_if do |remaining_guess|
      equal_clues?(remaining_guess, guess, clues)
    end
  end

  def next_guess
    score_guesses
    select_guess
  end

  def score_guesses
    @guess_scores = []
    possible_guesses.each do |guess|
      guess_score = 0
      POSSIBLE_CLUES.each do |clue|
        remaining_guesses.each do |remaining_guess|
          guess_score += 1 if equal_clues?(remaining_guess, guess, clue)
        end
      end
      guess_scores << guess_score
    end
  end

  def select_guess
    max_index = guess_scores.index(guess_scores.max)
    possible_guesses[max_index]
  end

  def equal_clues?(guess, code, clues)
    board.create_clues(guess, code).eql?(clues)
  end

  def code_cracked?
    p clues
    guess.eql?(secret_code)
  end
end
