class AddCreatedAndLastEditedByToDefinition < ActiveRecord::Migration[6.1]
  def change
    change_table :definitions do |t|
      t.references :created_by
      t.references :last_edited_by
    end

    execute <<SQL
      UPDATE definitions, (SELECT definition_versions.definition_id, definition_versions.updated_by FROM definition_versions,
                  (SELECT definition_id, MIN(updated_at) AS updated_at FROM definition_versions GROUP BY definition_id) x
                  WHERE definition_versions.definition_id = x.definition_id AND definition_versions.updated_at = x.updated_at
              ) AS y
        SET created_by_id = y.updated_by
        WHERE definitions.id = y.definition_id
SQL

    execute <<SQL
      UPDATE definitions, (SELECT definition_versions.definition_id, definition_versions.updated_by FROM definition_versions,
          (SELECT definition_id, MAX(updated_at) AS updated_at FROM definition_versions GROUP BY definition_id) x
          WHERE definition_versions.definition_id = x.definition_id AND definition_versions.updated_at = x.updated_at
      ) AS y
        SET last_edited_by_id = y.updated_by
        WHERE definitions.id = y.definition_id
SQL
  end
end
