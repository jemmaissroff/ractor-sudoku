require "forwardable"

class Candidate
  extend Forwardable

  attr_reader :ractor
  attr_accessor :group_count

  def initialize
    @group_count = 0
    @ractor = Ractor.new do
      value = Ractor.receive
      3.times do
        Ractor.yield value
      end
    end
  end

  def_delegators :@ractor, :send, :take
end
