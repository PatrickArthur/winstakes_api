class CreateProfiles < ActiveRecord::Migration[7.0]
  def change
    create_table :profiles do |t|
      t.references :user, null: false, foreign_key: true
      t.string :photo
      t.string :first_name
      t.string :last_name
      t.string :user_name
      t.date :date_of_birth
      t.string :city
      t.string :state
      t.string :zip_code
      t.text :interests

      t.timestamps
    end
  end
end
