class CreateVoters < ActiveRecord::Migration
  def self.up
    create_table :voters do |t|
    end
  end

  def self.down
    drop_table :voters
  end
end
