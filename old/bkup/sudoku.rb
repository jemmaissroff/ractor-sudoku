require "./group.rb"
require "./candidate.rb"
require "./grid.rb"

g = Grid.new
g.candidates[0][0][0][0].send true
g.candidates[0][1][0][0].send true


