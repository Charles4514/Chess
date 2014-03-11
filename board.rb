require './pieces.rb'
class Board

  def initialize
    @grid = Array.new(8) {Array.new(8)}
    set_pieces
  end

  def in_check?(color)
  end

  def move(start, end_pos)
  end

  def set_pieces
    vars = [@grid, position, color]
    back_row_courtiers = [Rook.new(*vars), Knight.new(*vars), Bishop.new(*vars)]
    back_row = [back_row_courtiers, King.new(*vars),
                Queen.new(*vars), back_row_courtiers.reverse]

    color = :white
    court = 0
    pawns = 1
    2.times do

      back_row.each_with_index do |piece,index|
        position = [court,index]
        @grid[position] = piece
      end

      8.times do |index|
        position = [pawns,index]
        @grid[position] = Pawn.new(*vars)
      end

      color = :black
      court = 7
      pawns = 6
    end

  end

  def [](pos)
    row, col = pos
    @grid[row][col]
  end

end