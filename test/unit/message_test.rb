require File.dirname(__FILE__) + '/../test_helper'

class MessageTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  def test_can_create
    user1 = a_test_user
    user2 = a_test_user2
    message = Message.new(:from_user => user1.id, :to_user => user2.id, :title => 'Lorem', :body => 'Ipsum')

    assert message.valid?

    assert message.save
  end
end
