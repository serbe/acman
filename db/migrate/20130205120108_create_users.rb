class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :surname
      t.string :name
      t.string :s_name
      t.string :ip
      t.string :group

      t.timestamps
    end
  end
end
