class DefinitionVersion < ActiveRecord::Base
  belongs_to :definition
  
  def <=>(other)
    word <=> other.word
  end

  def editor
    begin
      User.find( self[:updated_by] )
    rescue ActiveRecord::RecordNotFound
      nil
    end
  end

end
