class Product < ApplicationRecord
	belongs_to :creator, class_name: 'User'
	has_many :challenges 

	validates :name, presence: true
end
