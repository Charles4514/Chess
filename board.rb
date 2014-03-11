require './pieces.rb'
require 'debugger'
class Board

  attr_reader :grid
  def initialize
    @grid = Array.new(8) {Array.new(8)}
    set_pieces
  end

  def in_check?(col)
    king = @grid.flatten.find { |piece| !piece.nil? &&
                                piece.class.to_s == "King" &&
                                piece.color == col}

    pieces = @grid.flatten.select { |piece| !piece.nil? &&
                                    piece.class.to_s != "King" &&
                                    piece.color != col}

    pieces.each do |piece|
      return true if piece.moves.any? { |move| move == king.position }
    end

    false
  end

  def move(start, end_pos)
    temp = self[start]
    raise 'There is no piece there.' if self[start] == nil

    raise 'You cannot move there.' unless self[start].moves.include?(end_pos)

    self[start] = nil
    self[end_pos] = temp
    self[end_pos].move_piece(end_pos)
  end

  def row_setup(vars)

    back_row_courtiers = [Rook.new(*vars), Knight.new(*vars),
                          Bishop.new(*vars)]
    back_row_courtiers2 = [Rook.new(*vars), Knight.new(*vars),
                           Bishop.new(*vars)].reverse
    back_row_courtiers + [King.new(*vars), Queen.new(*vars)] +
                         back_row_courtiers2
  end

  def set_pieces
    position = []
    color = :white
    vars = [self, position, color]

    court = 0
    pawns = 1

    2.times do |i|

      back_row = row_setup(vars)

      back_row = back_row.reverse if i == 1

      back_row.each_with_index do |piece,index|
        position = [court,index]
        vars[1] = position
        self[position] = piece
      end

      8.times do |index|
        position = [pawns,index]
        vars[1] = position
        self[position] = Pawn.new(*vars)
      end

      vars[2] = :black
      court = 7
      pawns = 6
    end

  end

  def board_dup
    board_dup = Board.new

    @grid.each_with_index do |row, indexr|
      row.each_with_index do |piece, indexc|
        position = [indexr,indexc]
        if self[position].dup.nil?
          board_dup[position] = nil
        else
          board_dup[position] = board_dup[position].dup_piece(self[position], board_dup)
        end
      end
    end
    board_dup
  end

  def [](pos)
    row, col = pos
    @grid[row][col]
  end

  private

  def []=(pos,value)
    row,col = pos
    @grid[row][col] = value
  end

end