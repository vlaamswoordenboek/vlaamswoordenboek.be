require "application_system_test_case"

class VisitAsAnonymousUsersTest < ApplicationSystemTestCase
  test "visiting the index" do
    visit root_path

    assert_selector "h1", text: "Welkom bij het Vlaams woordenboek"
    assert_selector "h2", text: "capteren" # Check word of the day is filled in

    (all 'a', text: 'meer').first.click # Click on the info of the word of the day

    assert_text 'Dagelijks kiezen we een woord van de dag'
    click_link 'capteren' # CLick on the term

    # The term page should show 2 definitions
    assert_text 'Onze databank bevat de volgende beschrijving(en) van "capteren"'
    assert_text 'opnemen van een film'
    assert_text 'ontvangen van radio- of tv-signaal'

    # Go back to start
    click_link 'Wees welgekomen'

    assert_text 'Een willekeurige selectie'
    (all 'a', text: 'meer')[1].click # Click on the more for a random selection
    assert_text 'Dit is een willekeurige selectie woorden van wat het Vlaams woordenboek zoal te bieden heeft.'

    # Go back to start
    click_link 'Wees welgekomen'
    click_link 'Top woorden'
    assert_text 'Dit zijn de top Vlaamse termen volgens het aantal positieve stemmen.'
    assert_text 'topword'

    # Go back to start
    click_link 'Wees welgekomen'
    click_link 'Recent'

    assert_text 'De onderstaande definities zijn de laatst toegevoegde definities van Vlaamse termen in ons woordenboek.'
    assert_text 'capteren'

    click_link 'Wees welgekomen'

    (all 'a', text: 'johndoe').first.click
  end
end
