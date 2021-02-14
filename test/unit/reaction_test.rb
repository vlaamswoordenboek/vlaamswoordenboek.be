require File.dirname(__FILE__) + '/../test_helper'

class ReactionTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  def test_can_create
    definition = Definition.create!(:word => 'Test', :description => 'Test', :example => 'Test')
    reaction = Reaction.create!(:title => 'Test', :body => 'Test', :definition_id => definition.id)

    assert reaction.valid?

    assert reaction.save
  end
end
