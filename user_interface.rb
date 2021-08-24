module UserInterface
  def player_mode_prompt
    "Would you rather be the code MAKER or the code BREAKER?"
  end

  def player_guess_prompt
    "Make an attempt at cracking the code! (4-digits between 1 and 6)"
  end

  def invalid_guess_prompt
    "Invalid guess. Please input a 4-digit number between 1 and 6."
  end

end