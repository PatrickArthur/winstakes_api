class AddProfileIdToLikes < ActiveRecord::Migration[7.0]
  def change
    add_column :likes, :profile_id, :integer
  end
end
