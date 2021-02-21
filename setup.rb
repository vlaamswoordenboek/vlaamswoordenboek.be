Wotd.transaction do
  user = User.create!(:email => 'nathan@nathansamson.be', :login => 'aliekens', :password => 'ABBAACDC', :password_confirmation => 'ABBAACDC')

  defin = Definition.create!(:word => 'Test', :description => "Test", :example => 'Test', :updated_by => user)

  Wotd.create!(:definition_id => defin.id, :date => Date.today - 1)
end
