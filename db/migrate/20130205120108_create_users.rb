class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :surname
      t.string :name, :null => false
      t.string :s_name
      t.string :ip
      t.integer :group

      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
