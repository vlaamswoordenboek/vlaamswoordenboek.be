require "test_helper"

class ForumTopicTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  def test_can_create
    forum = Forum.create!(:title => 'Test', :body => 'Test')
    forumtopic = Forumtopic.new(:forum => forum, :title => 'Topic', :body => 'Body', user: users(:user1))

    assert forumtopic.valid?

    assert forumtopic.save
  end
end
