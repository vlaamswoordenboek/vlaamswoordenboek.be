class CreateDefinitions < ActiveRecord::Migration
  def self.up
    create_table :definitions do |t|
      t.column :word, :string
      t.column :definition, :text
      t.column :example, :text
      
      t.column :positivevotes, :integer, :null => false, :default => 0
      t.column :negativevotes, :integer, :null => false, :default => 0
      t.column :rating, :float, :null => false, :default => 0
      
      t.column :created_by, :integer
      t.column :created_at, :datetime
    end
  end

  def self.down
    drop_table :definitions
  end
end
