require File.expand_path('../boot', __FILE__)

require 'rails/all'

Bundler.require(:default, Rails.env) if defined?(Bundler)

module Cms
  class Application < Rails::Application
    config.autoload_paths += [
      # DumboCMS
      "#{config.root}/lib",
      "#{config.root}/app/apps",
      "#{config.root}/app/concerns",
      
      # XML-RPC APIs
      "#{config.root}/app/apis",

      # CarrierWave
      "#{config.root}/app/uploaders",
      
      # Liquid
      "#{config.root}/app/filters",
      "#{config.root}/app/tags"
    ]

    config.encoding = "utf-8"
    config.filter_parameters += [ :password, :password_confirmation ]
    
    # FIXME
    # FIXME add required keys
    # FIXME recursively
    config.dumbocms_path = File.expand_path('../dumbocms.yml', __FILE__)
    config.dumbocms = OpenStruct.new(YAML::load(File.open(Rails.configuration.dumbocms_path))["dumbocms"].symbolize_keys.merge(:production => true))

    config.middleware.use(ExceptionNotifier, {
      :email_prefix => Rails.configuration.dumbocms.noc_subject_prefix,
      :sender_address => [
        Rails.configuration.dumbocms.noc_sender_name,
        "<#{Rails.configuration.dumbocms.noc_sender_address}>",
      ],
      :exception_recipients => [
        Rails.configuration.dumbocms.noc_recipients.split(",").map(&:strip)
      ].flatten
    })
  end
end
