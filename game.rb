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
    @player_mode = 'BREAKER'
    @secret_code = []
    @remaining_guesses = POSSIBLE_GUESSES.clone
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
    remaining_guesses.delete_if do |solution|
      board.create_clues(solution.to_s.split(''), guess, []).eql?(clues)
    end
    @guess_scores = remaining_guesses.collect do |remaining_guess|
      @guess_score = 0
      POSSIBLE_GUESSES.each do |possible_guess|
        POSSIBLE_CLUES.each do |possible_clue|
          if board.create_clues(possible_guess.to_s.split(''), remaining_guess.to_s.split(''), []).eql?(possible_clue)
            @guess_score += 1
          end
        end
      end
    end
    p guess_scores
    p remaining_guesses[guess_scores.index(guess_scores.max)]
  end

  def valid_input?(input)
    input.length == 4 && input.all? { |code| code.to_i.between?(1, 6) }
  end

  def code_cracked?
    guess.eql?(secret_code)
  end
end
