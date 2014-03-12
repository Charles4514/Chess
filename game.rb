require './board.rb'#is ./ required?
require './pieces.rb'

class Game

  attr_accessor :board

  def initialize

    @board = Board.new
    @player1 = HumanPlayer.new(:white)
    @player2 = HumanPlayer.new(:black)

  end

  def render_board
    @board.grid.reverse.each do |row|
      row.each do |space|
        unless space.nil?
          print space.class.to_s[0..1] + " "
        else
          print "__ "
        end
      end
      print "\n"
    end
  end

  def play
    render_board
    while true

      [@player1, @player2].each do |player_turn|
        return "#{something something}" if @board.checkmate(player_turn.color)
        player_turn.play_turn(@board)
        render_board
      end

    end
  end
end

class Player

  attr_reader :color

  def initialize(color)
    @color = color

  end

  def play_turn(board)

    begin
      start_pos, end_pos = input_move
      board.move(start_pos, end_pos)
    rescue StandardError => e
      puts "#{e.message}"
      retry
    end
  end
end

class HumanPlayer < Player

  def input_move
    puts "What's your move?"
    puts "Where are you moving from? [x,y]"
    move_from = gets.chomp.split(',').map!{|x| x.to_i}
    puts "Where are you moving to? [x,y]"
    move_to = gets.chomp.split(',').map!{|x| x.to_i}

    [move_from, move_to]
  end

end