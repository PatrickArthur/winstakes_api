class CreateWonks < ActiveRecord::Migration[7.0]
  def change
    create_table :wonks do |t|
      t.text :content
      t.references :user, null: false, foreign_key: true
      t.references :profile, null: false, foreign_key: true

      t.timestamps
    end
  end
end
