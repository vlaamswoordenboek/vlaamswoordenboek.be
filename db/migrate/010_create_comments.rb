class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.column :title, :string 
      t.column :body, :text
      t.column :user_id, :integer
      t.column :created_at, :datetime
      t.column :resource_id, :integer 
      t.column :resource_type, :string    
    end
  end

  def self.down
    drop_table :comments
  end
end
