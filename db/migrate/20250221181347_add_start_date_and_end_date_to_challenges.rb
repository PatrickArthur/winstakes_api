class AddStartDateAndEndDateToChallenges < ActiveRecord::Migration[7.0]
  def change
    add_column :challenges, :start_date, :datetime
    add_column :challenges, :end_date, :datetime
    remove_column :challenges, :duration, :integer
  end
end
