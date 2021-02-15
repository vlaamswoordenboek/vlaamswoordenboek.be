class Vote < ActiveRecord::Base
  belongs_to :voter, optional: true
  belongs_to :definition
end
