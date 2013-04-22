class AddImagemToUsers < ActiveRecord::Migration
  def change
    add_column :users, :avatar, :string
  end
end
