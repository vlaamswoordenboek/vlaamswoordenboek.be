class CreateForumtopics < ActiveRecord::Migration
  def self.up
    create_table :forumtopics do |t|
      t.column :title, :string 
      t.column :body, :text
      t.column :user_id, :integer
      t.column :created_at, :datetime
      t.column :forum_id, :integer;
    end
  end

  def self.down
    drop_table :forumtopics
  end
end
