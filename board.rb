class Board
  CODE_COLORS = {
    '1' => "\e[1;41m 1 \e[0m",
    '2' => "\e[1;42m 2 \e[0m",
    '3' => "\e[1;43m 3 \e[0m",
    '4' => "\e[1;44m 4 \e[0m",
    '5' => "\e[1;45m 5 \e[0m",
    '6' => "\e[1;46m 6 \e[0m"
  }.freeze

  CLUE_SYMBOLS = {
    '*' => "\e[1;31m\u25CF \e[0m",
    '?' => "\e[1;37m\u25CF \e[0m",
    '_' => "\e[1;37m\u25CB \e[0m"
  }.freeze

  def create_clues(guess, code, clues)
    guess.each_index do |index|
      clues << if guess[index] == code[index]
                 '*'
               elsif guess.include?(code[index])
                 '?'
               else
                 '_'
               end
    end
    clues.sort!
  end

  def display_board(guess, clues)
    guess.each { |code| print "#{CODE_COLORS[code]} " }
    print "\e[1m Clues: \e[0m"
    clues.each { |code| print CLUE_SYMBOLS[code].to_s }
    print "\n"
  end
end
