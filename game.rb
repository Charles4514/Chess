class Game

  def initialize

    @board = Board.new
    player_1 = HumanPlayer.new(:white)
    player_2 = HumanPlayer.new(:black)

  end

  def play

    while true

      [player1,player2].each do |player_turn|
        checkmate(player_turn.color)
        player_turn.play_turn






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

class HumanPlayer < Player

  def initialize
  end

  def input_move
    puts "What's your move?"
    puts "Where are you moving from? [x,y]"
    move_from = gets.chomp.split(',').map!{|x| x.to_i}
    puts "Where are you moving to? [x,y]"
    move_to = gets.chomp.split(',').map!{|x| x.to_i}

    [move_from, move_to]
  end

end