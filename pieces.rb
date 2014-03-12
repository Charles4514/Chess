class Piece

  attr_reader :color
  attr_accessor :position

  def initialize(board, position, color)
    @board = board
    @position = position
    @color = color
  end

  def moves
    raise "DON'T DO THAT"
  end

  def valid_moves
    old_pos = self.position
    old_piece = self
    safe_moves = []

    moves.each do |move|
      duped_board = @board.dup
      duped_piece = duped_board[old_pos]
      duped_board.move!(old_pos, move)
      duped_piece.move_piece(move)

      unless duped_board.in_check?(old_piece.color)
        safe_moves << move
      end
    end
    safe_moves
  end

  #put these methods in board class
  def space_full?(pos)
    !@board[pos].nil? && @board[pos].color == self.color
  end
  #this too
  def has_enemy?(pos)
    !@board[pos].nil? && @board[pos].color != self.color
  end

  def dup(old_piece, new_board)
    old_piece.class.new(new_board, old_piece.position, old_piece.color)
  end

  #move to board class as well
  def check_move?(new_position)
    if new_position[0].between?(0,7) &&
       new_position[1].between?(0,7) &&
       !space_full?(new_position)
      return true
    end
    false
  end

end

class SlidingPiece < Piece

  DIAGONALS = [[1,1],[1,-1],[-1,1],[-1,-1]]
  ORTHOGONALS = [[0,1],[1,0],[0,-1],[-1,0]]

  def moves
    possible_moves = []
    move_dirs.each do |dir|
      new_position = position
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

#have constants for deltas
class Bishop < SlidingPiece

  def move_dirs
    DIAGONALS
  end

end

class Rook < SlidingPiece

  def move_dirs
    ORTHOGONALS
  end

end

class Queen < SlidingPiece

  def move_dirs
    ORTHOGONALS + DIAGONALS
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
    possible_moves
  end

end

class Knight < SteppingPiece

  def move_pattern
    [[2,1],[2,-1],[-2,1],[-2,-1],[1,2],[-1,2],[1,-2],[-1,-2]]
  end

end

class King < SteppingPiece

  def move_pattern
    [[1,1],[1,-1],[-1,1],[-1,-1],[0,1],[1,0],[0,-1],[-1,0]]
  end

end


class Pawn < Piece

  def moves
    possible_moves = []

    if self.color == :white && @board[[position[0] + 1, position[1]]].nil?
      possible_moves << [position[0] + 1, position[1]]

      if self.position[0] == 1 && @board[[position[0] + 2, position[1] ]].nil?
         possible_moves << [position[0] + 2, position[1]]
       end

    end

    if self.color == :black && @board[[position[0] - 1, position[1]]].nil?
      possible_moves << [position[0] - 1, position[1]]

      if self.position[0] == 6 && @board[[position[0] - 2, position[1] ]].nil?
        possible_moves << [position[0] - 2, position[1]]
      end

    end

    possible_moves += check_capture
    possible_moves
  end

  def check_capture
    possible_moves = []
    positions = [[1,1],[1,-1]] if self.color == :white
    positions = [[-1,1],[-1,-1]] if self.color == :black
    positions.each do |p|
      new_position = [@position[0] + p[0], @position[1] + p[1]]
      if !@board[new_position].nil? && @board[new_position].color != self.color
        possible_moves << new_position if check_move?(new_position)
      end
    end
    possible_moves
  end
end