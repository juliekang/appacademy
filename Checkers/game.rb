require_relative 'piece'
require_relative 'board'
require 'colorize'

class Game
  ALPHA = ("a".."h").to_a

  # remember user inputs x, y and should be converted to y, x
  attr_accessor :board

  def initialize
    @board = Board.new
    @color = :red
  end

  def run
    @board.to_s
    puts "Welcome to Checkers!"
    puts ""

    until @board.win?(:red) || @board.win?(:black)
      puts "Red is \u2659 , Black is \u265F .  You are #{@color}."
      puts "Enter sequence of moves (example: e5, f4, e3)."
      moves = gets.chomp.split(', ')

      moves.map! { |move| move = string_into_coord(move) }

      while @board.make_moves(moves) == false
        puts "Invalid move! Please try again:"
        moves = gets.chomp.split(', ')

        moves.map! { |move| move = string_into_coord(move) }
      end

      @board.to_s
      switch_color
    end
    switch_color
    puts "Congratulations! #{@color} wins!"
  end

  def string_into_coord(str)
    coord = str.split('').reverse!
    coord[0] = coord[0].to_i
    coord[1] = ALPHA.index(coord[1])
    coord
  end

  def switch_color
    @color == :red ? @color = :black : @color = :red
  end

end

g = Game.new
g.run
