class Board
  CODE_COLORS = {
    '1' => "\e[41m\e[1m 1 \e[0m",
    '2' => "\e[42m\e[1m 2 \e[0m",
    '3' => "\e[43m\e[1m 3 \e[0m",
    '4' => "\e[44m\e[1m 4 \e[0m",
    '5' => "\e[45m\e[1m 5 \e[0m",
    '6' => "\e[46m\e[1m 6 \e[0m"
  }

  def display_board(guess)
    guess.to_s.split('').each {|code| print "#{CODE_COLORS[code]} "}
  end
end