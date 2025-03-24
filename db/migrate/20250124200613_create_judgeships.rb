class CreateJudgeships < ActiveRecord::Migration[7.0]
  def change
    create_table :judgeships do |t|
      t.references :user, null: false, foreign_key: true
      t.references :challenge, null: false, foreign_key: true

      t.timestamps
    end

    add_index :judgeships, [:user_id, :challenge_id], unique: true
  end
end
