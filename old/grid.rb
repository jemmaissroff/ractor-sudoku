class Grid
  DEPTH = 2
  BREAK_STR = "-" * (DEPTH ** 2 * 2 + DEPTH)

  attr_reader :candidates

  # @param board [Array[Array<Integer, Nil>]]
  def initialize()
    # rows
    @candidates = DEPTH.times.map do
      # columns
      DEPTH.times.map do
        # squares
        (DEPTH ** 2).times.map do
          # cells
          (DEPTH ** 2).times.map do
            Candidate.new
          end
        end
      end
    end

    groups = []
    (0...DEPTH).each do |row|
      (0...DEPTH).each do |col|
        (0...(DEPTH ** 2)).each do |candidate|
          square_candidates = []
          cell_candidates = []
          (0...(DEPTH ** 2)).each do |cell|
            # Tricky here - doing cell and candidate in one iteration
            square_candidates << @candidates[row][col][cell][candidate]
            cell_candidates << @candidates[row][col][candidate][cell]
          end
          groups << Group.new(candidates: square_candidates)
          groups << Group.new(candidates: cell_candidates)
        end
      end
    end

    (0...(DEPTH ** 2)).each do |candidate|
      (0...DEPTH).each do |constant|
        row_candidates = [[],[],[]]
        col_candidates = [[],[],[]]
        (0...DEPTH).each do |iter|
          (0...(DEPTH ** 2)).each do |cell|
            # cell / DEPTH is the tricky part here
            # it means that 0-.DEPTH, DEPTH-5, 6-.(DEPTH ** 2) are all together which is what we
            # want for the rows
            row_candidates[cell / DEPTH] << @candidates[constant][iter][cell][candidate]
            # cell % DEPTH means we get 0,DEPTH,6; 1,4,7; .DEPTH,5,.(DEPTH ** 2) together which is what
            # we want for the cols
            col_candidates[cell % DEPTH] << @candidates[iter][constant][cell][candidate]
          end
        end

        (col_candidates + row_candidates).each do |cands|
          groups << Group.new(candidates: cands) unless cands.empty?
        end
      end
    end
  end

  def input_candidate(row:, col:, candidate:)
    translated_row = row / DEPTH
    translated_col = col / DEPTH
    cell = row - translated_row * DEPTH

  end

  # All 0 indexed (including candidate value)
  def candidate(row:, column:, cell:, candidate_value:)
    cadidates[row][column][cell][candidate_value]
  end

  def print_grid
    res = (DEPTH ** 2).times.map { "" }
    candidates.each_with_index do |row_cands, row_index|
      row_cands.each_with_index do |col_cands, col_index|
        col_cands.map do |square_cands|
          square_cands.map(&:ractor).map(&:take).find_index(true)
        end.to_a.each_slice(DEPTH).with_index do |slice, slice_index|
          res[DEPTH * row_index + slice_index] <<
            (col_index == 0 ? "" : " | ") + slice.join(" ")
        end
      end
    end
    (1...DEPTH).each { |index| res.insert(DEPTH * index, BREAK_STR)}
    puts res.join("\n")
  end
end
