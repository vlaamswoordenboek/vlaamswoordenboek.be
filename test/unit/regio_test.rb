require File.dirname(__FILE__) + '/../test_helper'

class RegioTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  def test_have_some_options
    assert_equal "Regio onbekend", Regio::OPTIONS[0].options[0].name
  end
end
