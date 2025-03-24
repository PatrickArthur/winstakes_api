class AddTypetoWonk < ActiveRecord::Migration[7.0]
  def change
    add_column :wonks, :wonk_type, :string, default: "profile"
  end
end
