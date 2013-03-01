class AddDetailsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :compname, :string
    add_column :users, :macadress, :string
  end
end
