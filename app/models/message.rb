class Message < ActiveRecord::Base
  belongs_to :sender, class_name: 'User', foreign_key: :from_user
  belongs_to :receiver, class_name: 'User', foreign_key: :to_user

  attr_accessor :receiver_login
end
