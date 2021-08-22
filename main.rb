code_colors = {
  '1' => "\e[41m\e[1m 1 \e[0m",
  '2' => "\e[42m\e[1m 2 \e[0m",
  '3' => "\e[43m\e[1m 3 \e[0m",
  '4' => "\e[44m\e[1m 4 \e[0m",
  '5' => "\e[45m\e[1m 5 \e[0m",
  '6' => "\e[46m\e[1m 6 \e[0m"
}

code_colors.each {|number, color| print "#{color} "}