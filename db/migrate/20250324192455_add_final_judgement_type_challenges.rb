class AddFinalJudgementTypeChallenges < ActiveRecord::Migration[7.0]
  def change
    add_column :challenges, :finals_judging, :string
  end
end
