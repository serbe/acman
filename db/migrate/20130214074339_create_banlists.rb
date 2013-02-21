class CreateBanlists < ActiveRecord::Migration
  def change
    create_table :banlists do |t|
      t.string :name, :unique => true, :null => false

      t.timestamps
    end
  end
end
