require "application_system_test_case"

class SignupTest < ApplicationSystemTestCase
  test "logging in and creating a new definition" do
    visit root_path

    assert_selector "h1", text: "Welkom bij het Vlaams woordenboek"
    assert_selector "h2", text: "capteren" # Check word of the day is filled in

    click_link 'ingelogd'

    page.find '#centercontent' do |center|
      center.fill_in 'login', with: 'johndoe'
      center.fill_in 'password', with: 'password'
      center.click_button 'Log in'
    end

    assert_text 'Een nieuwe beschrijving toevoegen'

    fill_in 'definition[word]', with: 'goesting'
    fill_in 'definition[properties]', with: 'de ~ (v.), ~en'
    fill_in 'definition[description]', with: 'zin, lust, trek goesting hebben voor, in, naar, achter iets'
    fill_in 'definition[example]', with: 'Hij ging tegen zijn goesting naar ’t school.'
    click_button 'Creëer'

    assert_text 'Uw nieuwe term werd succesvol in onze databank bewaard. Bedankt voor uw bijdrage!'
  end
end
