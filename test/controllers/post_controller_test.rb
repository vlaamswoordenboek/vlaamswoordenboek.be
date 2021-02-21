require "test_helper"

class PostControllerTest < ActionDispatch::IntegrationTest
  test "inbox as anoymous redirects to root" do
    get posts_path

    assert_response :redirect
  end

  test "inbox as loggeed in user shows inbox" do
    login_as(users(:user1))
    get posts_path

    assert_response :success
  end

  test "outbox as loggeed in user shows" do
    login_as(users(:user1))
    get outbox_posts_path

    assert_response :success
  end

  test "it shows a message for the user" do
    login_as(users(:user1))
    get post_path(messages(:from_user2_to_user1).id)

    assert_response :success
  end

  test "it does not show a message for another user" do
    login_as(users(:user1))
    get post_path(messages(:from_user2_to_user3).id)

    assert_response :redirect
  end

  test "can create a message as logged in user" do
    login_as(users(:user1))
    get new_post_path

    assert_response :success

    assert_difference -> { Message.where(receiver: users(:user2)).count } do
      post posts_path, params: { message: { receiver_login: users(:user2).login, title: 'A fancy message', body: "Hello World" } }
    end

    assert_equal 'Uw nieuw bericht werd succesvol verzonden.', flash[:notice]
    assert_response :redirect

    get outbox_posts_path
    assert_response :success
  end

  test "can not create a message as anonymous" do
    get new_post_path
    assert_response :redirect

    assert_no_difference -> { Message.where(receiver: users(:user2)).count } do
      post posts_path, params: { message: { receiver_login: users(:user2).login, title: 'A fancy message', body: "Hello World" } }
    end

    assert_response :redirect
  end
end
