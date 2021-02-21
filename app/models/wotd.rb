class Wotd < ActiveRecord::Base
  belongs_to :definition

  scope :past, -> { where("date <= ?", Date.today).order('date DESC') }

  def self.today
    Wotd.past.first
  end
end
