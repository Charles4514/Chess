class Board

  attr_reader :grid
  def initialize
    @grid = Array.new(8) { Array.new(8) }
    set_pieces
  end

  def in_check?(color)
    king = get_king(color)
    pieces = get_pieces(!color)

    pieces.each do |piece|
      return true if piece.moves.any? { |move| move == king.position }
    end

    false
  end

  def get_king(color)
    @grid.flatten.compact.find do |piece|
      piece.class == King && piece.color == color
    end
  end

  def get_pieces(color)
    @grid.flatten.compact.select do |piece|
      piece.color == color
    end
  end

  #maybe get to return both checkmate and color
  def checkmate(color)
    pieces = get_pieces(color)

    pieces.each do |piece|
      return false unless piece.valid_moves.empty?
    end
    true
  end

  def move!(start, end_pos)
    self[start], self[end_pos] = nil, self[start]
    self[end_pos].position = end_pos
  end

  def move(start, end_pos)
    if self[start] == nil
      raise StandardError.new 'There is no piece there.'
    end

    unless self[start].moves.include?(end_pos)
      raise StandardError.new 'You cannot move there.'
    end

    unless self[start].valid_moves.include?(end_pos)
      raise StandardError.new 'You would be in check.'
    end

    move!(start, end_pos)
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

      place_court(back_row, court, pawns)

      vars[2] = :black
      court = 7
      pawns = 6
    end

  end

  def place_court(back_row, court, pawns)
    back_row.each_with_index do |piece,index|
      position = [court,index]
      self[position] = piece
      self[position].position = position

      position = [pawns,index]
      vars[1] = position
      self[position] = Pawn.new(*vars)
    end
  end

  def dup
    board_dup = Board.new

    grid.each_with_index do |row, indexr|
      row.each_with_index do |piece, indexc|
        position = [indexr,indexc]
        if self[position].nil?
          board_dup[position] = nil
        else
          board_dup[position] = self[position].dup(self[position], board_dup)
        end
      end
    end
    board_dup
  end

  def [](pos)
    row, col = pos
    grid[row][col]
  end

  def []=(pos,value)
    row,col = pos
    grid[row][col] = value
  end

end