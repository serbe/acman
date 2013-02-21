class CreatePcres < ActiveRecord::Migration
  def change
    create_table :pcres do |t|
      t.string :name
      t.integer :banlist_id

      t.timestamps
    end
  end
end
