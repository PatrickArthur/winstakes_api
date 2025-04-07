# app/models/wallet.rb

class Wallet < ApplicationRecord
  belongs_to :user
  has_many :tokens

  def balance
    tokens.sum(:value)
  end

  def adjust!(amount)
    tokens.create!(
      user: self.user,
      wallet: self,
      value: amount,
      transaction_type: amount.positive? ? "credit" : "debit"
    )
  end
end