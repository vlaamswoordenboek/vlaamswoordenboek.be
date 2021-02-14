require File.dirname(__FILE__) + '/../test_helper'

class UserTest < Test::Unit::TestCase
  # Replace this with your real tests.
  def test_can_create
    user = User.new(:email => 'johndoe3@example.org', :login => 'user3', :password => 'ABBAACDC', :password_confirmation => 'ABBAACDC')

    assert user.valid?

    assert user.save
  end
end
