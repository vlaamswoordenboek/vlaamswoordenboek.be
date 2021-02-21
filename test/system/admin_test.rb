require "application_system_test_case"

class AdminTest < ApplicationSystemTestCase
  test "logging in deleting stuff" do
    visit root_path

    click_link 'ingelogd'

    page.find '#centercontent' do |center|
      center.fill_in 'login', with: 'aliekens'
      center.fill_in 'password', with: 'password'
      center.click_button 'Log in'
    end

    assert_difference -> { Definition.count }, -1 do
      accept_alert do
        (all 'a', text: 'verwijder')[1].click
        sleep 5
      end

      assert_text 'Uw beschrijving werd verwijderd.'
    end

    visit root_path
    (all 'a', text: '1 reactie(s)')[0].click

    assert_difference -> { Reaction.count }, -1 do
      (all 'a', text: 'verwijder')[1].click

      assert_text 'Uw reactie werd verwijderd.'
    end
  end
end
