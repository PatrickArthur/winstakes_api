class AddEntryFeeToChallenges < ActiveRecord::Migration[6.1]
  def change
    add_column :challenges, :entry_fee, :integer, default: 0
  end
end
