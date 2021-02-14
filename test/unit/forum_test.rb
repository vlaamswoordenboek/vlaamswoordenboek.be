require File.dirname(__FILE__) + '/../test_helper'

class ForumTest < Test::Unit::TestCase
  # Replace this with your real tests.
  def test_can_create
    forum = Forum.new(:title => 'Test', :body => 'Test')

    assert forum.valid?

    assert forum.save
  end
end
