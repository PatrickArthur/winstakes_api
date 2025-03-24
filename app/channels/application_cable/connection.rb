module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
    end

  protected

    def find_verified_user
      token = request.params[:token] || request.headers['Authorization']
      return reject_unauthorized_connection unless token

      decoded_token = decode_jwt(token)
      user_id = decoded_token[0]['sub'] # Assuming the payload contains a `sub` (subject) representing the user_id

      if (current_user = User.find_by(id: user_id))
        current_user
      else
        reject_unauthorized_connection
      end
    rescue JWT::DecodeError, JWT::ExpiredSignature, JWT::VerificationError
      reject_unauthorized_connection
    end

    def decode_jwt(token)
      JWT.decode(token, Rails.application.credentials.fetch(:secret_key_base), true, { algorithm: 'HS256' })
    end
  end
end
