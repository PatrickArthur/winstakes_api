class CreateChallengeParticipants < ActiveRecord::Migration[7.0]
  def change
    create_table :challenge_participants do |t|
      t.references :user, foreign_key: true
      t.references :challenge, foreign_key: true
      t.timestamps
    end
  end
end
