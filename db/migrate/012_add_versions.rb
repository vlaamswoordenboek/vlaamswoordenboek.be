class AddVersions < ActiveRecord::Migration
  def self.up
    #    add_column :definitions, :version, :integer
    rename_column :definitions, :created_by, :updated_by
    rename_column :definitions, :created_at, :updated_at
    Definition.create_versioned_table
    execute 'INSERT INTO definition_versions (id, definition_id, word, description, example, regio, updated_by, updated_at, version ) SELECT id, id, word, description, example, regio, updated_by, updated_at, 1 FROM definitions'
    execute 'update definitions set version=id'
  end

  def self.down
    Definition.drop_versioned_table
    rename_column :definitions, :updated_by, :created_by
    rename_column :definitions, :updated_at, :created_at
    remove_column :definitions, :version
  end
end
