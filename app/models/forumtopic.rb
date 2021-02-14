class Forumtopic < ActiveRecord::Base
  belongs_to :forum
  belongs_to :user
  has_many :comments, :as => :resource, :dependent => :destroy
  validates_presence_of :title, :body
end
