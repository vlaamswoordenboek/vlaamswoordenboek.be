require "test_helper"

class ReactionTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  def test_can_create
    definition = Definition.create!(:word => 'Test', :description => 'Test', :example => 'Test', updated_by: users(:user1).id)
    reaction = Reaction.create!(:title => 'Test', :body => 'Test', :definition_id => definition.id, creator: users(:user1))

    assert reaction.valid?

    assert reaction.save
  end
end
