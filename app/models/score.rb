class Score < ApplicationRecord
  belongs_to :entry
  belongs_to :criterion
  belongs_to :judge, class_name: 'User', foreign_key: 'user_id'

  validates :value, presence: true, numericality: { greater_than_or_equal_to: 0 }
end
