class AddFromUserIdToNotifications < ActiveRecord::Migration[7.0]
  def change
    add_column :notifications, :from_user_id, :integer
    add_index :notifications, :from_user_id
  end
end
