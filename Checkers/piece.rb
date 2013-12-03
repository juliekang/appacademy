class Piece
  RED_SLIDES = [[-1, 1], [-1, -1]]
  BLACK_SLIDES = [[1, 1], [1, -1]]
  RED_JUMPS = [[-2, 2], [-2, -2]]
  BLACK_JUMPS = [[2, 2], [2, -2]]

  attr_accessor :color, :board, :pos, :is_king

  def initialize(color, board, pos)
    @color = color
    @board = board
    @pos = pos
    @is_king = false
  end

  def evaluate_move(start, stop)
    start_color = @board.grid[start[0]][start[1]].color
    start_king = @board.grid[start[0]][start[1]].is_king

    dx = stop[0] - start[0]
    ref = nil

    case dx
    when -1
      return perform_slide(start, stop, RED_SLIDES) if (start_color == :red || start_king)
    when 1
      return perform_slide(start, stop, BLACK_SLIDES) if (start_color == :black || start_king)
    when -2
      return perform_jump(start, stop, RED_JUMPS) if (start_color == :red || start_king)
    when 2
      return perform_jump(start, stop, BLACK_JUMPS) if (start_color == :black || start_king)
    else 
      return false
    end
    false
  end

  def perform_slide(start, stop, constant)
    if possible_moves(start, constant).include?(stop)
      return false if is_occupied?(stop)
      start_piece = @board.grid[start[0]][start[1]]

      @board.grid[stop[0]][stop[1]] = start_piece
      @board.grid[start[0]][start[1]] = nil
      self.pos = stop 
      maybe_promote

      return true
    else
      return false
    end
  end

  def possible_moves(start, constant)
    moves = []
    start_x = start[0]
    start_y = start[1]

    constant.each do |deltas|
      dx = deltas[0]
      dy = deltas[1]
      new_coord = [start_x + dx, start_y + dy]

      moves << new_coord unless off_board?(new_coord)
    end
    moves
  end

  def off_board?(position)
    position[0] > 7 || position[0] < 0 || position[1] > 7 || position[1] < 0
  end

  def perform_jump(start, stop, constant)
    return false if !possible_moves(start, constant).include?(stop)
    return false if is_occupied?(stop)

    dx = stop[0] - start[0]
    dy = stop[1] - start[1]
    between_piece = @board.grid[start[0] + dx / 2][start[1] + dy / 2]

    return false unless between_piece.color != @board.grid[start[0]][start[1]].color

    if between_piece.color == :red
      @board.captured_red << between_piece
    else
      @board.captured_black << between_piece
    end

    @board.grid[stop[0]][stop[1]] = @board.grid[start[0]][start[1]]
    @board.grid[start[0]][start[1]] = nil

    self.pos = stop
    maybe_promote
    between_piece.pos = nil
    @board.grid[start[0] + dx / 2][start[1] + dy / 2] = nil

    return true
  end

  def is_occupied?(position)
    @board.grid[position[0]][position[1]] != nil
  end

  def maybe_promote
    @is_king = true if (@pos[0] == 0 && @color == :red) || (@pos[0] == 7 && @color == :black)
  end

  def perform_moves(move_sequence)
    moves = move_sequence

    until moves.length == 0
      start = moves.shift
      stop  = moves.shift

      puts "start = #{start} stop = #{stop}"
      return false if evaluate_move(start, stop) == false

      break if moves.length == 0
      moves.unshift(stop) 
    end
    true
  end

  def to_s
    if @color == :red
      if @is_king == true
        "\u2654"
      else
        "\u2659"
      end
    else
      if @is_king == true
        "\u265A"
      else
        "\u265F"
      end
    end
  end

end