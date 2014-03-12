require './game.rb'

game = Game.new

orig = [[6,6], [6,5], [6,0], [1,5], [0,4], [7,1]]
dest = [[4,6], [4,5], [5,0], [3,5], [3,7], [5,2]]

orig.length.times do |i|

  game.board.move(orig[i],dest[i])

end

# p game.board[[4,7]].color
# p game.board[[4,7]].valid_moves
# p game.board[[7,5]].valid_moves
# p game.board[[7,5]].color

game.render

p 'white wins?'
p game.board.checkmate(:black)
p 'black wins?'
p game.board.checkmate(:white)

