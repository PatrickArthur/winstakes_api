# Create this controller if it doesn't exist yet

class ScoresController < ApplicationController
  before_action :authenticate_user!

  def create
    entry = Entry.find(params[:entry_id])
    criterion = Criterion.find(params[:criterion_id])
    score = Score.new(
      entry: entry,
      criterion: criterion,
      judge: current_user,
      value: params[:value]
    )

    if score.save
      render json: score, status: :created
    else
      render json: score.errors, status: :unprocessable_entity
    end
  end
end