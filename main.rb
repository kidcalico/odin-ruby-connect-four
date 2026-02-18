# ⚫️ black circle
# Unicode: U+26AB U+FE0F, UTF-8: E2 9A AB EF B8 8F
# 🟡 yellow circle
# Unicode: U+1F7E1, UTF-8: F0 9F 9F A1
# 🔴 red circle
# Unicode: U+1F534, UTF-8: F0 9F 94 B4
# ⚪️ white circle
# Unicode: U+26AA U+FE0F, UTF-8: E2 9A AA EF B8 8F

require_relative './lib/board'
require 'rubocop'

class Play
  attr_accessor :board_array

  def initialize
    @board = Board.new
    @board_array = @board.board_array
    @last_column = nil
    @last_row = nil
  end

  def display_board
    puts @board_array.join()
  end

  def turn(color)
    display_board
    prompt(color)
    move = get_input
    move(color, move)
  end
  
  def prompt(color)
    puts "Yellow to play:" if color == 'yellow'
    puts "Red to play:" if color =='red'
    print "Choose a column (1-7) "
  end

  def get_input
    loop do
      int = gets.chomp.to_i
      return int unless int < 1 || int > 7 || !int.is_a?(Integer)
      puts "Please enter a number between 1 and 7!"
    end
  end

  def move(color, move)
    row = 6
    loop do
      if @board_array[row][move] == @board.blank
        @last_column = move
        @last_row = row
        return @board_array[row][move] = @board.public_send(color)
      elsif row == 1
        puts "Column #{move} is full, try another move."
        return
      else
        row -= 1
      end
    end
  end

  def winner?(row, column, color)
    piece = match(color)
    if column_win?(row, column, piece) == true || row_win?(row, column, piece) == true || diagonal_win?(row, column, piece) == true
      return true
    else
      return false
    end
  end

  def match(color)
    return "\e[0;44m\u{1F7E1}\e[0m" if color == 'yellow'
    return "\e[0;44m\u{1F534}\e[0m" if color == 'red'
  end

  def column_win?(row, column, piece)
    return true if @board_array[row + 1][column] == piece && 
      @board_array[row + 2][column] == piece && @board_array[row + 3][column] == piece
  end

  def row_win?(row, column, piece)
    return true if @board_array[row][column - 3] == piece &&
       @board_array[row][column - 2] == piece && @board_array[row][column - 1] == piece
    return true if @board_array[row][column - 2] == piece &&
       @board_array[row][column - 1] == piece && @board_array[row][column + 1] == piece
    return true if @board_array[row][column - 1] == piece &&
       @board_array[row][column + 1] == piece && @board_array[row][column + 2] == piece
    return true if @board_array[row][column + 1] == piece &&
       @board_array[row][column + 2] == piece && @board_array[row][column + 3] == piece
  end

  def diagonal_win?(row, column, piece)
    return true if @board_array[row - 3][column - 3] && @board_array[row - 2][column - 2] && @board_array[row - 1][column - 1]
    return true if @board_array[row - 2][column - 2] && @board_array[row - 1][column - 1] && @board_array[row + 1][column + 1]
    return true if @board_array[row - 1][column - 1] && @board_array[row + 1][column + 1] && @board_array[row + 2][column + 2]
    return true if @board_array[row + 1][column + 1] && @board_array[row + 2][column + 2] && @board_array[row + 3][column + 3]

    return true if @board_array[row - 3][column + 3] && @board_array[row - 2][column + 2] && @board_array[row - 1][column + 1]
    return true if @board_array[row - 2][column + 2] && @board_array[row - 1][column + 1] && @board_array[row + 1][column - 1]
    return true if @board_array[row - 1][column + 1] && @board_array[row + 1][column - 1] && @board_array[row + 2][column - 2]
    return true if @board_array[row + 1][column - 1] && @board_array[row + 2][column - 2] && @board_array[row + 3][column - 3]
  end

  def play
    loop do
      turn('yellow')
      # if winner?(@last_row, @last_column, 'yellow') == true
      #   puts "Congratulations!!! Yellow is the winner!"
      #   display_board
      #   return
      # end
      turn('red')
      # if winner?(@last_row, @last_column, 'red') == true
      #   puts "Congratulations!!! Red is the winner!"
      #   display_board
      #   return
      # end
    end
  end
end

game = Play.new
game.play