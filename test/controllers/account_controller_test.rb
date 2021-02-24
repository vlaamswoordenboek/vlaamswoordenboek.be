require "test_helper"

class AccountControllerTest < ActionDispatch::IntegrationTest
  test "user can login" do
    post login_path, params: { login: 'johndoe', password: 'password' }
    assert_response :redirect

    assert_equal 'Ge zijt succesvol ingelogd', flash[:notice]
    assert_equal session[:user], users(:user1).id
  end

  test "user can logout" do
    sign_in_as(users(:user1))

    get logout_path

    assert_response :redirect
    assert_equal 'Ge zijt nu uitgelogd.', flash[:notice]
  end

  test "user can signup" do
    post account_path, params: {
      user: {
        login: 'newuser',
        email: 'newuser@example.org',
        password: 'safe_password',
        password_confirmation: 'safe_password'
      }
    }
    assert_response :redirect
    assert_equal 'Merci om u in te schrijven! Ge kunt nu nieuwe woorden aan het woordenboek toevoegen.', flash[:notice]

    user = User.find_by(login: 'newuser')
    assert user.authenticated?('safe_password')
    assert_not user.authenticated?('other_password')
  end

  test "user can fail the signup" do
    post account_path, params: {
      user: {
        login: 'newuser',
        email: 'newuser@example.org',
        password: 'safe_password2',
        password_confirmation: 'safe_password'
      }
    }
    assert_response :success

    user = User.find_by(login: 'newuser')
    assert user.nil?
  end

  test "user can look at settings" do
    sign_in_as(users(:user1))

    get edit_account_path
    assert_response :success
  end

  test "user can change settings" do
    sign_in_as(users(:user1))

    patch account_path, params: { user: { details: 'my bio' } }
    assert_response :redirect
    assert_equal 'Uw aanpassing werd succesvol in onze databank bewaard.', flash[:notice]

    user = User.find(users(:user1).id)
    assert_equal 'my bio', user.details
  end

  test "anonymous user can not look at settings" do
    get edit_account_path
    assert_response :redirect
  end

  test "anonymous user can not change settings" do
    patch account_path, params: { user: { details: 'my bio' } }
    assert_response :redirect
  end

  private

  def sign_in_as(user)
    post login_path, params: { login: user.login, password: 'password' }
  end
end
