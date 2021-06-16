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
  attr_reader :candidate_ractors

  def initialize(candidate_ractors)
    @candidate_ractors = candidate_ractors
    Ractor.new candidate_ractors do |candidate_ractors|
      value = false
      8.times do
        r, value = Ractor.select(*candidate_ractors)
        candidate_ractors.delete r
        puts "deleted #{r} #{value}"
        break if value
      end

      puts "22"
      candidate_ractors.each { puts _1; _1.send !value }
      Ractor.yield true
    end
  end
end

class Board
  attr_accessor :board, :groups

  def initialize
    @board = 3.times.map do |row|
      3.times.map do |col|
        3.times.map do |cell_row|
          3.times.map do |cell_col|
            9.times.map do |value|
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
      (candidate[:row] * 3 + candidate[:cell_row])
    end.values.map do |row|
      row.group_by do |candidate|
        candidate[:value]
      end
    end.map(&:values).flatten(1)

    cols = board.group_by do |candidate|
      (candidate[:col] * 3 + candidate[:cell_col])
    end.values.map do |row|
      row.group_by do |candidate|
        candidate[:value]
      end
    end.map(&:values).flatten(1)

    cells = board.group_by do |candidate|
      (candidate[:row] * 3 + candidate[:col])
    end.values.map do |row|
      row.group_by do |candidate|
        candidate[:value]
      end
    end.map(&:values).flatten(1)

    # Only one not by value
    squares = board.group_by do |candidate|
      (candidate[:row] * 3 + candidate[:col])
    end.values.map do |row|
      row.group_by do |candidate|
      (candidate[:cell_row] * 3 + candidate[:cell_col])
      end
    end.map(&:values).flatten(1)

    @groups =  (rows + cols + cells + squares).map do |group|
      Group.new(group.map { _1[:ractor] })
    end
  end

  def send(row, col, cell_row, cell_col, value)
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
end

board = Board.new
board.send(0,0,0,1,7)
board.send(0,0,1,1,6)
board.send(0,0,2,0,2)
board.send(0,1,0,1,2)
board.send(0,1,2,0,8)
board.send(0,2,0,1,4)
board.send(0,2,0,2,6)
board.send(0,2,1,0,8)
board.send(0,2,1,1,0)
board.send(0,2,2,0,7)
board.send(0,2,2,1,1)
board.send(0,2,2,2,5)
board.send(1,0,0,1,8)
board.send(1,0,0,2,4)
board.send(1,0,1,0,7)
board.send(1,0,1,1,1)
board.send(1,1,0,1,0)
board.send(1,1,0,2,7)
board.send(1,1,2,0,1)
board.send(1,1,2,1,3)
board.send(1,2,1,1,5)
board.send(1,2,1,2,0)
board.send(1,2,2,0,4)
board.send(1,2,2,1,8)
board.send(2,0,0,0,6)
board.send(2,0,0,1,0)
board.send(2,0,0,2,7)
board.send(2,0,1,1,5)
board.send(2,0,1,2,8)
board.send(2,0,2,0,4)
board.send(2,0,2,1,3)
board.send(2,1,0,2,2)
board.send(2,1,2,1,8)
board.send(2,2,0,2,8)
board.send(2,2,1,1,6)
board.send(2,2,1,2,7)

###
#
board.send(0,0,0,0,8)

