require "application_system_test_case"

class SignupTest < ApplicationSystemTestCase
  test "signing up via the home page" do
    visit root_path

    assert_selector "h1", text: "Welkom bij het Vlaams woordenboek"
    assert_selector "h2", text: "capteren" # Check word of the day is filled in

    click_link 'registreert'

    assert_text 'Kies een gebruikersnaam'

    fill_in 'user[login]', with: 'newuser'
    fill_in 'user[email]', with: 'johnnywalker@example.org'
    fill_in 'user[password]', with: 'P@ssword'
    fill_in 'user[password_confirmation]', with: 'P@ssword'

    click_on 'Akkoord!'

    assert_text 'Een nieuwe beschrijving toevoegen'
    assert_text 'Geef eventueel een aantal woordkenmerken aan'
    assert_text 'Kenmerken'

    click_on 'Log uit'
    assert_selector "h1", text: "Welkom bij het Vlaams woordenboek"

    assert_no_text 'Geef eventueel een aantal woordkenmerken aan'
  end
end
