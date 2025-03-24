class FavoriteJudgeSerializer < ActiveModel::Serializer
  attributes :id, :created_at  # Include common attributes you want
  belongs_to :profile
end