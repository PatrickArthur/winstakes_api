class ChangeValueColumnDecToken < ActiveRecord::Migration[7.0]
  def change
    change_column :tokens, :value, :decimal, precision: 10, scale: 0
  end
end
