class Criterion < ApplicationRecord
   belongs_to :challenge
   has_many :scores, dependent: :destroy

   validates :name, presence: true

   def self.update_criteria_for_challenge(challenge, criteria_params)
    # Convert hash into an array of criteria data
    formatted_criteria_params = criteria_params.values

    # Map the current criteria as a basis for updates/deletes
    existing_criteria = challenge.criteria.to_a # Convert ActiveRecord relation to array for mutability

    formatted_criteria_params.each do |criterion_data|
      # Find existing criterion by name to update,
      # assuming 'name' is unique within the scope of a challenge
      existing_criterion = existing_criteria.find { |c| c.name == criterion_data["name"] }

      if existing_criterion
        # Update the criterion
        existing_criterion.update!(name: criterion_data["name"], max_score: criterion_data["max_score"])
        # Remove successfully updated criteria from list of existing ones
        existing_criteria.delete(existing_criterion)
      else
        # Create a new criterion if no match is found
        challenge.criteria.create!(name: criterion_data["name"], max_score: criterion_data["max_score"])
      end
    end

    # Cleanup: destroy criteria that were not updated
    existing_criteria.each(&:destroy)
  end
end
