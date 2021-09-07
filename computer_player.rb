require_relative 'board'

class ComputerPlayer
  include Board

  attr_reader :possible_guesses, :remaining_guesses, :guess, :first_guess,
              :guess_scores, :clues

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
    @possible_guesses = POSSIBLE_GUESSES.collect { |code| code.to_s.split('') }
    @remaining_guesses = possible_guesses.clone
    @guess = %w[1 1 2 2]
    @first_guess = true
    @clues = []
  end

  def create_code
    Array.new(4) { rand(1..6).to_s }
  end

  def new_guess
    unless first_guess
      reduce_guesses
      next_guess
      @guess = remaining_guesses.min
    end
    @first_guess = false if first_guess
    possible_guesses.delete(guess)
    guess
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

  def new_clues(guess, secret_code)
    @clues = create_clues(guess, secret_code)
  end

  def equal_clues?(guess, code, clues)
    create_clues(guess, code).eql?(clues)
  end
end
