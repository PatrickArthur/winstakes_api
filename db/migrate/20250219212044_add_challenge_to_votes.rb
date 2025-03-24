class AddChallengeToVotes < ActiveRecord::Migration[7.0]
  def change
    add_reference :votes, :challenge, null: false, foreign_key: true
  end
end
