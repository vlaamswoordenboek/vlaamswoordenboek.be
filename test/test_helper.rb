ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  # Add more helper methods to be used by all tests here...

  def a_test_user
    user = users(:user1)
  end

  def a_test_user2
    user = User.create!(:email => 'johndoe2@example.org', :login => 'auser', :password => 'ABBAACDC', :password_confirmation => 'ABBAACDC')
  end
end
