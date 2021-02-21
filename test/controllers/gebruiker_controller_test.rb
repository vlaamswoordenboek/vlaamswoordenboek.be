require "test_helper"

class AcccountControllerTest < ActionDispatch::IntegrationTest
  test "get index work" do
    get users_path
    assert_response :success
  end

  test "get show work" do
    get user_path(id: users(:user1).login)
    assert_response :success
  end

  test "get show work as yourself" do
    post login_path, params: { login: 'johndoe', password: 'password' }
    get user_path(id: users(:user1).login)
    assert_response :success
  end

  test "get show work as someone else" do
    post login_path, params: { login: 'auser', password: 'password' }
    get user_path(id: users(:user1).login)
    assert_response :success
  end

  test "get reacties work" do
    get reactions_user_path(id: users(:user1).login)
    assert_response :success
  end

  test "get edits work" do
    get edits_user_path(id: users(:user1).login)
    assert_response :success
  end
end
