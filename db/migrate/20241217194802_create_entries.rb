class CreateEntries < ActiveRecord::Migration[7.0]
  def change
    create_table :entries do |t|
      t.references :challenge_participant, null: false, foreign_key: true
      t.string :title
      t.text :description
      t.string :status, default: 'draft'
      t.integer :score
      t.datetime :published_at
      t.string :visibility, default: 'private'

      t.timestamps
    end
  end
end
