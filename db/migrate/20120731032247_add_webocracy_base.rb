class AddWebocracyBase < ActiveRecord::Migration
  def self.up
    create_table :decisions do |t|
      t.integer :value, :default => 0
      t.integer :target_id
      t.string  :target_type
      t.integer :author_id
      t.string  :guid
      t.text :author_signature
      t.text :parent_author_signature
      t.timestamps
    end
    add_index :decisions, :guid, :unique => true
    add_index :decisions, :target_id
    #add_foreign_key(:decisions, :propositions)
    add_foreign_key(:decisions, :people, :column => :author_id)
  end

  def self.down
    drop_table :decisions
  end
end