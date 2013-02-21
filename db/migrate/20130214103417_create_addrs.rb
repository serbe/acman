class CreateAddrs < ActiveRecord::Migration
  def change
    create_table :addrs do |t|
      t.string :name
      t.integer :banlist_id

      t.timestamps
    end
  end
end
