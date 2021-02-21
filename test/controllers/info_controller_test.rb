require "test_helper"

class InfoControllerTest < ActionDispatch::IntegrationTest
  test "get info work" do
    get info_path
    assert_response :success
  end

  test "get updates work" do
    get updates_info_path
    assert_response :success
  end

  test "get regios work" do
    get regios_info_path
    assert_response :success
  end

  test "get feeds work" do
    get feeds_info_path
    assert_response :success
  end

  test "get contact work" do
    get contact_info_path
    assert_response :success
  end

  # TODO Voorwaarden, but there is no link to it?
  # TODO uitspraak, but there is no link to it?
end
