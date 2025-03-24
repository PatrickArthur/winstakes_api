class Wonk < ApplicationRecord
  belongs_to :profile
  belongs_to :user
  belongs_to :challenge, optional: true

  has_many :comments, dependent: :destroy

  has_many :likes, as: :likeable

  validates :content, presence: true, length: { maximum: 280 }
end