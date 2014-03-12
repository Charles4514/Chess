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

  #test when game class is written!
  def checkmate(color) #maybe get to return both checkmate and color
    pieces = @grid.flatten.select { |piece| !piece.nil? && piece.color == color}

    pieces.each do |piece|
      return false unless piece.valid_moves.empty?
    end
    true
  end

  def move!(start, end_pos)
    temp = self[start]
    self[start] = nil
    self[end_pos] = temp
    self[end_pos].move_piece(end_pos)
  end

  #add rescues in game class
  def move(start, end_pos)
    temp = self[start]

    if self[start] == nil
      raise StandardError.new 'There is no piece there.'
    end

    #separate moves that are impossible from ones that would put you in check
    unless self[start].valid_moves.include?(end_pos)
      raise StandardError.new 'You cannot move there.'
    end

    self[start] = nil
    self[end_pos] = temp
    self[end_pos].move_piece(end_pos)
  end

  def row_setup(*vars)

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

      back_row = row_setup(*vars)

      back_row = back_row.reverse if i == 1

      back_row.each_with_index do |piece,index|
        position = [court,index]
        vars[1] = position
        self[position] = piece
        self[position].move_piece(position)
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
        if self[position].nil?
          board_dup[position] = nil
        else
          # puts self[position].position
#           puts self[position].class
          board_dup[position] = self[position].dup_piece(self[position], board_dup)
        end
      end
    end
    board_dup
  end

  def [](pos)
    row, col = pos
    @grid[row][col]
  end

  # private

  def []=(pos,value)
    row,col = pos
    @grid[row][col] = value
  end

end