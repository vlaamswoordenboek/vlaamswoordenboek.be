require "test_helper"

class DefinitiesControllerTest < ActionDispatch::IntegrationTest
  test "recent RSS works" do
    get '/recent.xml'

    assert_response :success
  end

  test "wijzigingen RSS works" do
    get '/wijzigingen.xml'

    assert_response :success
  end

  test "word of the day RSS works" do
    get '/woordvandedag.xml'

    assert_response :success
  end
end
