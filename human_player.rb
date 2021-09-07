require_relative 'board'
require_relative 'user_interface'

class HumanPlayer
  include UserInterface
  include Board

  def create_code
    puts secret_code_prompt
    valid_input
  end

  def new_guess
    puts player_guess_prompt
    valid_input
  end

  def new_clues(guess, secret_code)
    create_clues(guess, secret_code)
  end
end
