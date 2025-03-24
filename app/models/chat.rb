class Chat < ApplicationRecord
	belongs_to :user1, class_name: "User", foreign_key: 'user1_id'
  	belongs_to :user2, class_name: "User", foreign_key: 'user2_id'

  	has_many :messages, dependent: :destroy

  	validates :user1_id, uniqueness: { scope: :user2_id }

  	def belongs_to_user?(user)
  		user1_id == user.id || user2_id == user.id
  	end
end
