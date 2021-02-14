class AddProperties < ActiveRecord::Migration
  def self.up
    add_column :definitions, :properties, :string, :null => false, :default => ""
    add_column :definition_versions, :properties, :string, :null => false, :default => ""
  end

  def self.down
    remove_column :definitions, :properties
    remove_column :definition_versions, :properties
  end
end
