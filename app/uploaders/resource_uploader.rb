require 'carrierwave/processing/mime_types'

class ResourceUploader < CarrierWave::Uploader::Base
  include CarrierWave::MimeTypes
  
  # Do not use Rackspace Cloud Files when testing.
  storage(:fog) unless Rails.env.test?
  
  process :set_content_type
end