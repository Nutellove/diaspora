# rake db:reset
# rake db:rebuild
# rake db:test:prepare

class AddWebocracyBase < ActiveRecord::Migration
  def self.up

    # DECISIONS
    #create_table :decisions do |t|
    #  t.integer :value, :default => 0
    #  t.integer :target_id
    #  t.string  :target_type
    #  t.integer :author_id
    #  t.string  :guid
    #  t.text :author_signature
    #  t.text :parent_author_signature
    #  t.timestamps
    #end
    #add_index :decisions, :guid, :unique => true
    #add_index :decisions, :target_id
    ##add_foreign_key(:decisions, :propositions)
    #add_foreign_key(:decisions, :people, :column => :author_id)

    # DELEGATIONS
    create_table :delegations do |t|
      t.integer :user_id
      t.integer :person_id
    end

    # PROPOSITIONS
    add_column(:posts, :closed, :boolean, :default => false)

  end

  def self.down
    remove_column(:posts, :closed)
    drop_table :delegations
    #drop_table :decisions
  end
end
