class CreateMessages < ActiveRecord::Migration
  def self.up
    create_table :messages do |t|
      
      t.column :from_user, :integer
      t.column :to_user, :integer

      t.column :title, :string
      t.column :body, :text

      t.column :created_at, :datetime
      
      t.column :read, :boolean, :null => false, :default => false
      
    end
  end

  def self.down
    drop_table :messages
  end
end
