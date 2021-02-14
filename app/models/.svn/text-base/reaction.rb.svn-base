class Reaction < ActiveRecord::Base
  belongs_to :definition
    def created_by
      begin
        User.find(self[:created_by])
      rescue ActiveRecord::RecordNotFound
        nil
      end
    end

end
