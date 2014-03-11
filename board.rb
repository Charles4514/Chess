require './pieces.rb'
require 'debugger'
class Board

  attr_accessor :grid
  attr_reader :blacks, :whites
  def initialize
    @blacks = []
    @whites = []
    @grid = Array.new(8) {Array.new(8)}
    set_pieces
  end

  def in_check?(col)
    king = @grid.flatten.select { |piece| !piece.nil? &&
                                  piece.class.to_s == "King" &&
                                  piece.color == col}[0]

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
    self[end_pos].position = end_pos #make a method for this in pieces?
  end

  def set_pieces
    position = []
    color = :white
    vars = [self, position, color]

    court = 0
    pawns = 1

    2.times do |i|

      back_row_courtiers = [Rook.new(*vars), Knight.new(*vars),
                            Bishop.new(*vars)]
      back_row_courtiers2 = [Rook.new(*vars), Knight.new(*vars),
                             Bishop.new(*vars)]
      back_row = back_row_courtiers + [King.new(*vars),
                 Queen.new(*vars)] + back_row_courtiers2.reverse

      back_row = back_row.reverse if i == 1

      back_row.each_with_index do |piece,index|
        position = [court,index]
        piece.position = position
        self[position] = piece

        i == 0 ? @whites << piece : @blacks << piece
      end

      8.times do |index|
        position = [pawns,index]
        self[position] = Pawn.new(*vars)
        self[position].position = position
        i == 0 ? @whites << self[position] : @blacks << self[position]
      end

      vars[2] = :black
      court = 7
      pawns = 6
    end

  end

  def [](pos)
    row, col = pos
    @grid[row][col]
  end

  def []=(pos,value)
    row,col = pos
    @grid[row][col] = value
  end

end