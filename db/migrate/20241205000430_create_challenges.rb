class CreateChallenges < ActiveRecord::Migration[7.0]
  def change
    create_table :challenges do |t|
      t.string :title
      t.text :description
      t.text :criteria_for_winning
      t.integer :duration
      t.string :prize
      t.references :creator, foreign_key: { to_table: :users }
      t.timestamps
    end
  end
end
