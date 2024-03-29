require "test_helper"

class VoteTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  def test_can_create
    definition = Definition.create!(:word => 'Test', :description => 'Test', :example => 'Test', updated_by: users(:user1).id)
    vote = Vote.new(:definition_id => definition.id)

    assert vote.valid?

    assert vote.save
  end
end
