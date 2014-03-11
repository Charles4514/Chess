require './board.rb'
class Piece

  attr_reader :color, :position

  def initialize(board, position, color)
    @board = board
    @position = position
    @color = color
  end

  def moves
    raise "DON'T DO THAT"
  end

  def space_full?(pos)
    !@board[pos].nil? && @board[pos].color == self.color
  end

  def has_enemy?(pos)
    !@board[pos].nil? && @board[pos].color != self.color
  end

  def move_piece(pos)
    @position = pos
  end

  def dup_piece(old_piece, new_board)
    duped = old_piece.dup
    duped.board = new_board
    duped
  end

  def check_move?(new_position)
    if new_position[0].between?(0,7) &&
       new_position[1].between?(0,7) &&
       !space_full?(new_position)
      return true
    end
    false
  end

end


#Sliding Piece
class SlidingPiece < Piece

  def moves
    possible_moves = []
    move_dirs.each do |dir|
      new_position = @position
      new_position = new_position[0]+dir[0], new_position[1]+dir[1]

      while check_move?(new_position)
        possible_moves << new_position
        break if has_enemy?(new_position)
        new_position = new_position[0]+dir[0], new_position[1]+dir[1]
      end

    end
    possible_moves
  end

end

#Sub-Sub-Class
class Bishop < SlidingPiece

  def move_dirs
    return [[1,1],[1,-1],[-1,1],[-1,-1]]
  end

end

class Rook < SlidingPiece

  def move_dirs
    return [[0,1],[1,0],[0,-1],[-1,0]]
  end

end

class Queen < SlidingPiece

  def move_dirs
    return [[1,1],[1,-1],[-1,1],[-1,-1],[0,1],[1,0],[0,-1],[-1,0]]
  end

end


class SteppingPiece < Piece

  def moves
    possible_moves = []
    move_pattern.each do |move|
      new_position = [position[0] + move[0]] + [position[1] + move[1]]
      if check_move?(new_position)
        possible_moves << new_position
      end
    end
  end

end

class Knight < SteppingPiece

  def move_pattern
    return [[2,1],[2,-1],[-2,1],[-2,-1],[1,2],[-1,2],[1,-2],[-1,-2]]
  end

end

class King < SteppingPiece

  def move_pattern
    return [[1,1],[1,-1],[-1,1],[-1,-1],[0,1],[1,0],[0,-1],[-1,0]]
  end

end


class Pawn < Piece

  def moves
    possible_moves = []

    if self.color == :white && @board[@position[0], @position[1] + 1].nil?
      possible_moves << [@position[0], @position[1] + 1]

      if self.position[0] = 1 && @board[@position[0], @position[1] + 2].nil?
         possible_moves << [@position[0], @position[1] + 2]
       end

    end

    if self.color == :black && @board[@position[0], @position[1] - 1].nil?
      possible_moves << [@position[0], @position[1] - 1]

      if self.position[0] = 6 && @board[@position[0], @position[1] - 2].nil?
        possible_moves << [@position[0], @position[1] - 2]
      end

    end

    possible_moves << check_capture
  end

  def check_capture
    possible_moves = []
    positions = [[1,1],[-1,1]] if self.color == :white
    positions = [[1,-1],[-1,-1]] if self.color == :black
    positions.each do |p|
      new_position = @position[0] + p[0], @position[1] + p[1]
      if !@board[new_position].nil? && @board[new_position].color != self.color
        possible_moves << new_position
      end
    end
    possible_moves
  end

end