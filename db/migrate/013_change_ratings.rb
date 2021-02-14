class ChangeRatings < ActiveRecord::Migration
  def self.up
    add_column :definitions, :newrating, :integer, :null => false, :default => 0
    execute 'UPDATE definitions set newrating=positivevotes-negativevotes'
    remove_column :definitions, :rating
    rename_column :definitions, :newrating, :rating

    add_column :definition_versions, :newrating, :integer, :null => false, :default => 0
    execute 'UPDATE definition_versions set newrating=positivevotes-negativevotes'
    remove_column :definition_versions, :rating
    rename_column :definition_versions, :newrating, :rating
  end

  def self.down
    add_column :definitions, :newrating, :float, :null => false, :default => 0
    execute 'UPDATE definitions set newrating=(positivevotes+1)/(negativevotes+1)'
    remove_column :definitions, :rating
    rename_column :definitions, :newrating, :rating

    add_column :definition_versions, :newrating, :float, :null => false, :default => 0
    execute 'UPDATE definition_versions set newrating=(positivevotes+1)/(negativevotes+1)'
    remove_column :definition_versions, :rating
    rename_column :definition_versions, :newrating, :rating
  end
end
