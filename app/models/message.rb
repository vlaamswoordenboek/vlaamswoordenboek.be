class Message < ActiveRecord::Base

  # the user who created the initial version for this definition
  def sender
    begin
      User.find( self[ :from_user ] )
    rescue ActiveRecord::RecordNotFound
      nil
    end
  end

  # the user who last updated the definition
  def receiver
    begin
      User.find( self[ :to_user ] )
    rescue ActiveRecord::RecordNotFound
      nil
    end
  end


end 