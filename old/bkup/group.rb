class Group
  def initialize(candidates:)
    candidates.each { |c| c.group_count+=1 }
    Ractor.new candidates.map(&:ractor) do |candidate_ractors|
      value = false
      1.times do
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
