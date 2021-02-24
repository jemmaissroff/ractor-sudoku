class Group
  def initialize(candidates:)
    candidates.each { |c| c.group_count+=1 }
    candidate_ractors = candidates.map(&:ractor)
    Ractor.new candidate_ractors do |candidate_ractors|
      value = false
      (Grid::DEPTH ** 2 - 1).times do
        r, value = Ractor.select(*candidate_ractors)
        candidate_ractors.delete(r)
        break if value
      end

      candidate_ractors.each do |candidate_ractor|
        candidate_ractor.send !value
      end
    end
  end
end
