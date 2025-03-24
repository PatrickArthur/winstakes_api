class CriterionSerializer < ActiveModel::Serializer
  attributes :id, :name, :max_score, :created_at, :updated_at

  # Include any other needed relationships or fields
end