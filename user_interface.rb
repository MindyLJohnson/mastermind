module UserInterface
  def player_mode_prompt
    'Would you rather be the code MAKER or the code BREAKER?'
  end

  def invalid_mode_prompt
    'Invalid input. Please input either MAKER or BREAKER.'
  end

  def secret_code_prompt
    'Create a 4-digit code between 1 and 6 for the Computer to break.'
  end

  def player_guess_prompt
    'Make an attempt at cracking the code! (4-digits between 1 and 6)'
  end

  def invalid_input_prompt
    'Invalid input. Please input a 4-digit number between 1 and 6.'
  end

  def valid_mode
    input = gets.chomp.upcase
    until valid_mode?(input)
      puts invalid_mode_prompt
      input = gets.chomp.upcase
    end
    input
  end

  def valid_mode?(input)
    input.include?('MAKER') || input.include?('BREAKER')
  end

  def valid_input
    input = gets.chomp.to_s.split('')
    until valid_input?(input)
      puts invalid_input_prompt
      input = gets.chomp.to_s.split('')
    end
    input
  end

  def valid_input?(input)
    input.length == 4 && input.all? { |code| code.to_i.between?(1, 6) }
  end
end
