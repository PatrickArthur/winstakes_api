class CreateScores < ActiveRecord::Migration[7.0]
  def change
    create_table :scores do |t|
      t.decimal :value
      t.references :entry, null: false, foreign_key: true
      t.references :criterion, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
