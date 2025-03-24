class AddJudgingMethodChallenge < ActiveRecord::Migration[7.0]
  def change
    add_column :challenges, :judging_method, :string
    add_column :challenges, :prize_type, :string, default: "tokens"
    add_column :challenges, :token_prize_percentage, :integer, default: 75
    add_column :challenges, :fixed_token_prize, :integer
    add_column :challenges, :product_id, :integer
  end
end
