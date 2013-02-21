class AddIpUniquenessIndex < ActiveRecord::Migration
  def up
    add_index :users, :ip, :unique => true
  end

  def down
    remove_index :users, :ip
  end
end
