class AddCounterCacheToDefinition < ActiveRecord::Migration[6.1]
  def change
    change_table :definitions do |t|
      t.integer :reactions_count
      t.integer :versions_count
    end

    execute <<SQL
      UPDATE definitions, (SELECT COUNT(*) AS count, definition_id FROM definition_versions GROUP BY definition_id) y
        SET definitions.versions_count = y.count
        WHERE definitions.id = y.definition_id
SQL

    execute <<SQL
  UPDATE definitions, (SELECT COUNT(*) AS count, definition_id FROM reactions GROUP BY definition_id) y
    SET definitions.reactions_count = y.count
    WHERE definitions.id = y.definition_id
SQL
  end
end
