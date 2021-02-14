require File.dirname(__FILE__) + '/../test_helper'

class CommentTest < Test::Unit::TestCase
  def test_can_create
    user = a_test_user
    comment = Comment.new(:title => 'Test', :body => 'Test', :user => user)

    assert comment.valid?

    assert comment.save
  end
end
