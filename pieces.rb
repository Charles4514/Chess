require './board.rb'
class Piece

  attr_accessor :position, :color

  def initialize(board, position, color)
    @board = board
    @position = position
    @color = color
  end

  def moves
  end

  def space_full?(pos)
    if board[pos].color == self.color
      return true
    end
    false
  end

  def check_move?(new_position)
    if new_position.between?(0,7) && !space_full?(new_position)
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

      while check_move?(new_position)
        new_position = new_position[0]+dir[0], new_position[1]+dir[1]
        possible_moves << new_position
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

    possible_moves = position[0], position[1] + 1 if self.color == :White
    possible_moves = position[0], position[1] - 1 if self.color == :Black
    possible_moves << check_capture(position)

    possible_moves
  end

  def check_capture(pos)
    possible_moves = []
    positions = [[1,1],[-1,1]] if self.color == :White
    positions = [[1,-1],[-1,-1]] if self.color == :Black
    positions.times do |p|
      new_position = pos[0] + p[0], pos[1] + p[1]
      if board[pos].color != self.color
        possible_move << new_position
      end
    end
    possible_move
  end

end