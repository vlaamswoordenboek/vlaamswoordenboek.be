class ChangeDefinitionColumn < ActiveRecord::Migration
  def self.up
    rename_column :definitions, :definition, :description
  end

  def self.down
    rename_column :definitions, :description, :definition
  end
end
