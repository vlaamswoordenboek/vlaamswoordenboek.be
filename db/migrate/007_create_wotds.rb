class CreateWotds < ActiveRecord::Migration
  def self.up
    create_table :wotds do |t|
      t.column :definition_id, :int
      t.column :date, :date
    end
  end

  def self.down
    drop_table :wotds
  end
end
