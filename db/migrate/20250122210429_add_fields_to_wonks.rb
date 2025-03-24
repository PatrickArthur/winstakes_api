class AddFieldsToWonks < ActiveRecord::Migration[7.0]
  def change
    add_reference :wonks, :challenge, foreign_key: true
  end
end
