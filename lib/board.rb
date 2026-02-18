class Board
  attr_accessor :board_array, :yellow, :red

  def initialize
    build_board
  end

  def blank
    "\e[0;44m\u{26AB}\e[0m"
  end

  def yellow
    "\e[0;44m\u{1F7E1}\e[0m"
  end

  def red
    "\e[0;44m\u{1F534}\e[0m"
  end

  def build_row
    @row = ["\e[0;44m \e[0m"]
    7.times do
      @row << blank
    end
    @row << "\e[0;44m \e[0m\n"
  end

  def build_board
    @board_array = [["\e[0;44m                \e[0m\n"]]
    6.times do
      @board_array << build_row
    end
    @board_array << ["\e[0;44m 1 2 3 4 5 6 7  \e[0m\n"]
  end

  def change_piece
    build_board
    @board_array[5][4] = yellow
    @board_array[5][3] = red
    puts @board_array.join
  end

end