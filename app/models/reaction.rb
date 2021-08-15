class Reaction < ActiveRecord::Base
  belongs_to :definition, counter_cache: true
  belongs_to :creator, class_name: 'User', foreign_key: :created_by

  def self.recent(count: 10, offset: 0)
    self.order('created_at DESC').limit(count).offset(offset)
  end
end
