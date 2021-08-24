class Game
  include UserInterface

  attr_reader :board, :player_mode, :clues, :guess, :secret_code

  def initialize
    @board = Board.new
    @player_mode = 'BREAKER'
    @clues = []
  end

  def play
    game_setup
    until code_cracked?
      if player_mode == 'BREAKER'
        player_crack_code
      else
        computer_crack_code
      end
      create_clues
      board.display_board(guess, clues)
    end
  end

  def game_setup
    puts player_mode_prompt
    @player_mode = gets.chomp
    make_code
  end

  def make_code
    if player_mode.upcase == 'MAKER'
      puts secret_code_prompt
      p @secret_code = gets.chomp.to_s.split('')
    else
      p @secret_code = Array.new(4) { rand(1..6).to_s }
    end
  end

  def player_crack_code
    puts player_guess_prompt
    @guess = gets.chomp.to_s.split('')
    until valid_guess?
      puts invalid_guess_prompt
      @guess = gets.chomp.to_s.split('')
    end
  end

  def valid_guess?
    guess.length == 4 && guess.all? { |code| code.to_i.between?(1, 6) }
  end

  def computer_crack_code
    p assess_clues
    @guess = Array.new(4) {rand(1..6).to_s}
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

  def code_cracked?
    guess.eql?(secret_code)
  end
end
