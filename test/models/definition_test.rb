require File.dirname(__FILE__) + '/../test_helper'

class DefinitionTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  def test_can_create
    definition = Definition.new(:word => 'Test', :description => 'Test', :example => 'Test', updated_by: users(:user1).id)

    assert definition.valid?

    assert definition.save
  end
end
