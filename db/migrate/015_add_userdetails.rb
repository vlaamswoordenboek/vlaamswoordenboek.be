class AddUserdetails < ActiveRecord::Migration
  def self.up
    add_column :users, :details, :text, :null => false, :default => ""
  end

  def self.down
    remove_column :definitions, :users
  end
end
