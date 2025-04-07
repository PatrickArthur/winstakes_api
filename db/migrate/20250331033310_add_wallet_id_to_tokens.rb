class AddWalletIdToTokens < ActiveRecord::Migration[7.0]
  def change
    add_reference :tokens, :wallet, null: false, foreign_key: true
  end
end
