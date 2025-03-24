Rails.application.configure do
  # Other configuration options...

  # Configure the default URL options
  config.action_mailer.default_url_options = { host: 'localhost', port: 4000 }
  
  Rails.application.reloader.to_prepare do
    ActiveStorage::Current.url_options = { host: 'localhost', port: 4000 }
  end
end