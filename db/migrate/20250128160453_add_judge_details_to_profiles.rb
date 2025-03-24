class AddJudgeDetailsToProfiles < ActiveRecord::Migration[7.0]
  def change
    add_column :profiles, :is_judge, :boolean, default: false
    add_column :profiles, :category, :string
    add_column :profiles, :bio, :text
  end
end
