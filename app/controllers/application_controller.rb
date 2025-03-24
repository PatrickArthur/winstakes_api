class ApplicationController < ActionController::API
	before_action :set_active_storage_url_options

	private

	def set_active_storage_url_options
	 	ActiveStorage::Current.url_options = { 
	 		set_active_storage_url_optionshost: request.host_with_port
	 	}
    end
end
