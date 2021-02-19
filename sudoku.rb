# candidate which receives a value and then sends that value to all of its groups
#
# group:
# when it receives 8 falses, sends true to all candidates (true one is only one still listening)
# if it receives a true, sends false to all candidates

class Group
  # ractor is this specific group's ractor that it's listening on
  # candidates_ractors is an array of all the ractors of the 9 candidates in this group
  def initialize(candidate_ractors:)
    candidate_ractors = candidate_ractors
    Ractor.new candidate_ractors do |candidate_ractors|
      value = false
      8.times do
        r, value = Ractor.select(*candidate_ractors)
        candidate_ractors.delete(r)
        break if value
      end

      candidate_ractors.each do |candidate_ractor|
        # begin / rescue or deal with closed errors or something
        candidate_ractor.send !value
      end
    end
  end
end

candidate_ractors = 3.times.map do
  Ractor.new do
    value = Ractor.receive
    3.times do
      Ractor.yield value
    end
  end
end

group = Group.new(candidate_ractors: candidate_ractors)

candidate_ractors[0].send false
candidate_ractors[1].send false

