class Comment < ActiveRecord::Base
  validates_presence_of :title, :body
  belongs_to :resource, :polymorphic => true
  belongs_to :user
  validates_presence_of :title, :body
end
