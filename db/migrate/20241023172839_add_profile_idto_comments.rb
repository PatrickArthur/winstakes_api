class AddProfileIdtoComments < ActiveRecord::Migration[7.0]
  def change
    add_column :comments, :profile_id, :integer
  end
end
