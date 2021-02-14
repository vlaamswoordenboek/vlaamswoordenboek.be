require File.dirname(__FILE__) + '/../test_helper'

class WotdTest < Test::Unit::TestCase
  # Replace this with your real tests.
  def test_can_create
    definition = Definition.create!(:word => 'Test', :description => 'Test', :example => 'Test')
    wotd = Wotd.new(:definition_id => definition.id, :date => Date.today - 1)

    assert wotd.valid?

    assert wotd.save
  end
end
