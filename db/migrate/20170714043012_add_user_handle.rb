class AddUserHandle < ActiveRecord::Migration
  def change
    add_column :tweets, :user_handle, :string
  end
end
