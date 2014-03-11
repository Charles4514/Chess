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
    back_row = [Rook.new(*vars), Knight.new(*vars), Bishop.new(*vars), King.new(*vars),]
    setup = []

  end

  def [](pos)
    row, col = pos
    @grid[row][col]
  end

end