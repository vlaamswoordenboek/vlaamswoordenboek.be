class Reaction < ActiveRecord::Base
  belongs_to :definition
    def created_by
      begin
        User.find(self[:created_by])
      rescue ActiveRecord::RecordNotFound
        nil
      end
    end

  def self.recent(count: 10, offset: 0)
    self.order('created_at DESC').limit(count).offset(offset)
  end
end
