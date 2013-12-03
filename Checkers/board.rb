require_relative "piece"
require "colorize"

class Board
  attr_accessor :grid, :captured_black, :captured_red

  def initialize
    @grid = Array.new(8) { Array.new(8) { } }
    @captured_black, @captured_red = [], []
    populate_grid
  end

  def populate_grid
    @grid.each_index do |row_num|
      (0..7).each do |space_num|
        if ((row_num == 0 && space_num % 2 == 1) ||
            (row_num == 1 && space_num % 2 == 0) ||
            (row_num == 2 && space_num % 2 == 1))
          @grid[row_num][space_num] = Piece.new(:black, self, [row_num, space_num]) 
        end
        if ((row_num == 5 && space_num % 2 == 0) ||
            (row_num == 6 && space_num % 2 == 1) ||
            (row_num == 7 && space_num % 2 == 0))
          @grid[row_num][space_num] = Piece.new(:red, self, [row_num, space_num]) 
        end
      end
    end

    # 11.times do |x|
    #   @captured_black << Piece.new(:black, self, [x,x])
    # end
    # @grid[3][4] = Piece.new(:black, self, [3, 4])
    # @grid[4][5] = Piece.new(:red, self, [4, 5])

  end

  def make_moves(move_array)
    first_move = move_array[0]
    start_piece = grid[first_move[0]][first_move[1]]
    return false if !start_piece
    
    start_piece.perform_moves(move_array)
  end

  def win?(color)
    if color == :red
      @captured_black.length == 12
    else
      @captured_red.length == 12
    end
  end

  def to_s
    counter = 0
    print "   a| b| c| d| e| f| g| h\n"
    @grid.each do |row|
      print "#{counter}|"
      row.each_with_index do |space, index|
        if space.is_a? Piece
          print " #{space.to_s} ".colorize(:background => :red) if (counter + index).even?
          print " #{space.to_s} ".colorize(:background => :black) if (counter + index).odd?
        else
          blank_red = " ".colorize(:background => :red)
          blank_black = " ".colorize(:background => :black)

          print "#{blank_red}#{blank_red}#{blank_red}" if (counter + index).even?
          print "#{blank_black}#{blank_black}#{blank_black}" if (counter + index).odd?
        end
      end
      print "\n"
      counter += 1
    end
    print "\n"
  end

end

# b = Board.new
# p b.to_s
# p b.win?(:black)
