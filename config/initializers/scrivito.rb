Scrivito.configure do |config|
  #
  # Uncomment following lines in order to explicitly set the tenant and the API key.
  # If not explicitly set, the tenant and the API key are obtained from the environment variables
  # SCRIVITO_TENANT and SCRIVITO_API_KEY.
  #
  # config.tenant = 'my-tenant-123'
  # config.api_key = 'secret'
  #

  # Disable the default routes to allow route configuration
  config.inject_preset_routes = false
  # Authentication stuff goes here...
    config.editing_auth { |env| Scrivito::User.system_user }

  config.default_image_transformation = { 
      width: 2000, height: 2000
    }
end
