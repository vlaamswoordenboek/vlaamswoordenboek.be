class CreateVotes < ActiveRecord::Migration
  def self.up
    create_table :votes do |t|
      t.column :voter_id, :integer
      t.column :definition_id, :integer
      t.column :value, :integer
    end
  end

  def self.down
    drop_table :votes
  end
end
