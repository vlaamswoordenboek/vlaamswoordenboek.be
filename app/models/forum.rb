class Forum < ActiveRecord::Base
  has_many :forumtopics, :dependent => :destroy
  has_many :comments, :through => :forumtopics, :dependent => :destroy
end
