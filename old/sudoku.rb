require "./group.rb"
require "./candidate.rb"
require "./grid.rb"

g = Grid.new

sleep 1
g.candidates[0][0][0][1].send true
g.candidates[0][0][1][2].send true
g.candidates[0][0][2][3].send true
g.candidates[0][0][0][3].send true
g.candidates[0][1][0][3].send true
g.candidates[0][1][1][0].send true
g.candidates[0][1][2][1].send true
g.candidates[1][1][0][2].send true
g.candidates[1][1][1][3].send true
sleep 1

g.print_grid
