class AddRegios < ActiveRecord::Migration
  def self.up
    add_column :definitions, :regio, :integer, :default => 0
  end

  def self.down
    remove_column :definitions, :regio
  end
end
