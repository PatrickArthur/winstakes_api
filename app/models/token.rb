class Token < ApplicationRecord
  belongs_to :user
  belongs_to :wallet

  enum transaction_type: { credit: "credit", debit: "debit" }
end
