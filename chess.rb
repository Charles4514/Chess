class Piece

  def initialize(board, position)
    @board = board
    @position = position
  end

  def moves
  end

  def space_full?(pos)
    if board(pos)[0] == piece
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
      #helper method!
      while new_position.between?(0,7) && !space_full?(new_position)
        new_position = new_position[0]+dir[0], new_position[1]+dir[1]
        possible_move << new_position
      end
    end

    possible_moves
  end

end

#Sub-Sub-Class
class Bishop < SlidingPiece

  def initialize(board, position)
    super(board, position)
  end

  def move_dirs
    return [[1,1],[1,-1],[-1,1],[-1,-1]]
  end

end


class Rook < SlidingPiece

  def initialize(board, position)
    super(board, position)
  end

  def move_dirs
    return [[0,1],[1,0],[0,-1],[-1,0]]
  end

end

class Queen < SlidingPiece

  def initialize(board, position)
    super(board, position)
  end

  def move_dirs
    return [[1,1],[1,-1],[-1,1],[-1,-1],[0,1],[1,0],[0,-1],[-1,0]]
  end

end



class SteppingPiece < Piece

  def moves
  end

end


class Pawn < Piece

  def initialize
  end

  def moves
  end

end