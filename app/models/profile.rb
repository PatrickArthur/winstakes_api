class Profile < ApplicationRecord
  belongs_to :user
  has_one_attached :photo
  has_many :wonks, dependent: :destroy
  has_many :comments, dependent: :destroy

  serialize :interests, Array

  validates :interests, array: { message: 'must be an array' }
  validates :category, presence: true, if: :is_judge?
end
