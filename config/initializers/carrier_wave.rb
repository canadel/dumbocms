CarrierWave::SanitizedFile.sanitize_regexp = /[^a-zA-Z0-9\.\-\+_]/u

api_key = Rails.configuration.dumbocms.rackspace_cloud_api_key
username = Rails.configuration.dumbocms.rackspace_cloud_username

case Rails.env.to_sym
when :test
  # Use the file storage for tests.
  CarrierWave.configure do |config|
    config.storage = :file
    config.enable_processing = false
  end
when :development
  # Use the dumbocms_development container for development.
  CarrierWave.configure do |config|
    config.fog_credentials = {
      :provider => 'Rackspace',
      :rackspace_username => username,
      :rackspace_api_key => api_key
    }
      
    config.store_dir = 'assets'
    config.fog_directory = 'dumbocms_development'
    config.fog_host = "http://c297464.r64.cf1.rackcdn.com"
  end
when :production
  # Use the dumbocms_production container for production.
  CarrierWave.configure do |config|
    config.fog_credentials = {
      :provider => 'Rackspace',
      :rackspace_username => username,
      :rackspace_api_key => api_key
    }
      
    config.store_dir = 'assets'
    config.fog_directory = 'dumbocms_production'
    config.fog_host = "http://c297466.r66.cf1.rackcdn.com"
  end
end
