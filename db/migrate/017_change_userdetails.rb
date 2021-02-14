class ChangeUserdetails < ActiveRecord::Migration
  def self.up
    change_column :users, :details, :text, :null => true
  end

  def self.down
    change_column :users, :details, :text, :null => false
  end
end
