require File.dirname(__FILE__) + '/../test_helper'

class DefinitionTest < Test::Unit::TestCase
  # Replace this with your real tests.
  def test_can_create
    definition = Definition.new(:word => 'Test', :description => 'Test', :example => 'Test')

    assert definition.valid?

    assert definition.save
  end
end
