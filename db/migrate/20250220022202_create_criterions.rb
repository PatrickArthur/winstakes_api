class CreateCriterions < ActiveRecord::Migration[7.0]
  def change
    create_table :criterions do |t|
      t.string :name
      t.integer :max_score
      t.references :challenge, null: false, foreign_key: true

      t.timestamps
    end
  end
end
