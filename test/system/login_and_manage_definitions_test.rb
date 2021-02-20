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

    click_link 'bewerk'

    fill_in 'definition[example]', with: 'Hij ging tegen zijn goesting naar ’t school. Goestingskes kosten geld.'
    click_button 'Bewerk'
    assert_text 'Uw aanpassing werd succesvol in onze databank bewaard. Bedankt voor uw bijdrage.'

    assert_text 'Onze databank bevat de volgende beschrijving(en) van "goesting"'
    click_link 'oudere versies'

    assert_text 'Versie 2'
    assert_text 'De beschrijving van deze term werd 2 keer aangepast.'

    (all 'a', text: '0 reactie(s)').first.click
    fill_in 'reaction[title]', with: 'Volledig eens'
    fill_in 'reaction[body]', with: 'Dat moest toch ook eens gezegd worden'
    click_button 'Voeg mijn reactie toe'

    assert_text 'Bedankt voor uw reactie!'
    (all 'a', text: '1 reactie(s)').first.click
    assert_text 'Volledig eens'
  end
end
