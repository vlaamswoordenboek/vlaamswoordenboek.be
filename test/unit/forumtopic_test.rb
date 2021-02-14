require File.dirname(__FILE__) + '/../test_helper'

class ForumTopicTest < Test::Unit::TestCase
  # Replace this with your real tests.
  def test_can_create
    forum = Forum.create!(:title => 'Test', :body => 'Test')
    forumtopic = Forumtopic.new(:forum => forum, :title => 'Topic', :body => 'Body')

    assert forumtopic.valid?

    assert forumtopic.save
  end
end
