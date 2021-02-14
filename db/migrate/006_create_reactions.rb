class CreateReactions < ActiveRecord::Migration
  def self.up
    create_table :reactions do |t|
      t.column :title, :string
      t.column :body, :text

      t.column :definition_id, :integer
      t.column :created_by, :integer
      t.column :created_at, :datetime
    end
  end

  def self.down
    drop_table :reactions
  end
end
