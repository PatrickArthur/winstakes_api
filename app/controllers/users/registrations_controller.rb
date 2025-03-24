# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  include RackSessionFix
  respond_to :json

  private

  def respond_with(resource, _opts = {})
    case request.method
    when "POST"
      if resource.persisted?
        render json: {
          status: { code: 200, message: "Signed up successfully." },
          data: UserSerializer.new(resource).as_json
        }, status: :ok
      else
        render json: {
          status: { code: 422, message: "User couldn't be created successfully. #{resource.errors.full_messages.to_sentence}" }
        }, status: :unprocessable_entity
      end
    when "DELETE"
      render json: {
        status: { code: 200, message: "Account deleted successfully." }
      }, status: :ok
    else
      head :method_not_allowed
    end
  end
end
