class AddFieldsToNotifications < ActiveRecord::Migration[7.0]
  def change
    add_column :notifications, :message, :string
    add_column :notifications, :link, :string
  end
end
