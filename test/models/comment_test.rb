require "test_helper"

class CommentTest < ActiveSupport::TestCase
  def test_can_create
    user = users(:user1)
    comment = Comment.new(:title => 'Test', :body => 'Test', :user => user)

    assert comment.valid?

    assert comment.save
  end
end
