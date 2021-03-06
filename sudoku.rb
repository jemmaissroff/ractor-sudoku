SIZE = 2

class Candidate
  attr_accessor :ractor

  def initialize
    @ractor = Ractor.new do
      value = Ractor.receive
      loop { Ractor.yield value }
    end
  end
end

class Group
  attr_reader :candidate_ractors, :candidates

  def initialize(candidates)
    @candidates = candidates
    @candidate_ractors = candidates.map { _1[:ractor] }
    Ractor.new candidate_ractors do |candidate_ractors|
      value = false
      (SIZE ** 2 - 1).times do
        r, value = Ractor.select(*candidate_ractors)
        candidate_ractors.delete r
        break if value
      end

      candidate_ractors.each { _1.send !value }
      Ractor.yield true
    end
  end
end

class Board
  attr_accessor :board, :groups

  def initialize
    @board = SIZE.times.map do |row|
      SIZE.times.map do |col|
        SIZE.times.map do |cell_row|
          SIZE.times.map do |cell_col|
            (SIZE ** 2).times.map do |value|
              {
                row: row,
                col: col,
                cell_row: cell_row,
                cell_col: cell_col,
                value: value,
                ractor: Candidate.new.ractor
              }
            end
          end.flatten
        end.flatten
      end.flatten
    end.flatten
  end

  def make_groups
    rows = board.group_by do |candidate|
      (candidate[:row] * SIZE + candidate[:cell_row])
    end.values.map do |row|
      row.group_by do |candidate|
        candidate[:value]
      end
    end.map(&:values).flatten(1)

    cols = board.group_by do |candidate|
      (candidate[:col] * SIZE + candidate[:cell_col])
    end.values.map do |row|
      row.group_by do |candidate|
        candidate[:value]
      end
    end.map(&:values).flatten(1)

    cells = board.group_by do |candidate|
      (candidate[:row] * SIZE + candidate[:col])
    end.values.map do |row|
      row.group_by do |candidate|
        candidate[:value]
      end
    end.map(&:values).flatten(1)

    # Only one not by value
    squares = board.group_by do |candidate|
      (candidate[:row] * SIZE + candidate[:col])
    end.values.map do |row|
      row.group_by do |candidate|
      (candidate[:cell_row] * SIZE + candidate[:cell_col])
      end
    end.map(&:values).flatten(1)

    @groups =  (rows + cols + cells + squares).map do |group|
#    @groups =  (cols).map do |group|
#      Group.new(group.map { _1[:ractor] })
      Group.new(group)
    end
  end

  def send(row, col, cell_row, cell_col, value)
    value = 0 if value == SIZE ** 2
    find(row, col, cell_row, cell_col, value)[:ractor].send true
  end

  def find(row, col, cell_row, cell_col, value)
    board.select do |square|
      square[:row] == row &&
      square[:col] == col &&
      square[:cell_row] == cell_row &&
      square[:cell_col] == cell_col &&
      square[:value] == value
    end.first
  end

  def print_solution
    puts board.select { _1[:ractor].take }.
      sort_by { [_1[:row], _1[:cell_row], _1[:col], _1[:cell_col]] }.
      map { _1[:value] }.
      each_slice(4).to_a.
      map { _1.join(" ").gsub("0", (SIZE ** 2).to_s) }.join("\n")
  end
end

board = Board.new
board.send(0,1,0,1,3)
board.send(0,1,1,1,2)
board.send(1,0,0,0,3)
board.send(1,0,1,0,4)
puts Ractor.count
board.make_groups
puts Ractor.count
board.print_solution


b2 = Board.new
b2.send(1,0,0,0,4)
b2.send(1,0,1,1,2)
b2.send(0,1,1,0,1)
b2.send(1,1,1,1,3)
b2.make_groups
puts Ractor.count
b2.print_solution
###
