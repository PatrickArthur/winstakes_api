require 'stripe'

class TokensController < ApplicationController
	before_action :authenticate_user!
	before_action :set_profile, only: [:index]

	def index
		if @profile
          render json: { wallet: @profile.user.tokens}, status: :ok
        else
          render json: { error: 'Profile not found' }, status: :not_found
        end
    rescue => e
    	render json: { error: "An error occurred: #{e.message}" }, status: :internal_server_error
    end

	def purchase
		amount = params[:cost] * 100

		# Create or retrieve a Customer
		customer = Stripe::Customer.create(email: current_user.email)

		# Create a PaymentIntent without automatically confirming it
		intent = Stripe::PaymentIntent.create({
		  amount: amount, # Amount in cents
		  currency: 'usd',
		  customer: customer.id,
		  # Do not try to confirm immediately; handle confirmation on client-side if needed.
		  automatic_payment_methods: {
		    enabled: true,
		  }
		})
   	
       	# If payment is successful, credit tokens to the user's account
       	token = Token.new(value: params[:tokens], user: current_user, expires_at: Time.current + 1.week, revoked: false)
       	current_user.tokens << token
       	
       	if current_user.save
	      # Broadcast the new token activity
	      ActionCable.server.broadcast "wallet_channel_#{current_user.id}", { 
	        action: 'purchase', 
	        data: { token_value: token.value, total_tokens: current_user.tokens.sum(:value) }
	      }
	    end

       	render json: { success: true, payment_intent_id: intent.id, client_secret: intent.client_secret, tokens: current_user.tokens }
     	rescue Stripe::CardError => e
       		render json: { success: false, error: e.message }, status: :payment_required
    end

    private

    def set_profile
    	@profile = Profile.find_by(id: params[:id])
    end
end
