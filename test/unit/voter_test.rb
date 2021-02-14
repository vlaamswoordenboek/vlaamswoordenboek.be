require File.dirname(__FILE__) + '/../test_helper'

class VoterTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  def test_can_count_voters
    assert_equal 0, Voter.count
  end
end
