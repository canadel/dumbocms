case Rails.env.to_sym
when :production
  # http://docs.sendgrid.com/documentation/get-started/integrate/examples/rails-example-using-smtp/
  ActionMailer::Base.smtp_settings = {
    :address => 'smtp.sendgrid.net',
    :port => 587,
    :authentication => :plain,
    :enable_starttls_auto => true,
    :domain => 'dumbocms.com', # FIXME
    :password => 'eidFumOr', # FIXME
    :user_name => 'maurycy'
  }
when :test
  true
when :development
  true
end

ActionMailer::Base.default_url_options[:host] = Rails.configuration.dumbocms.hostname # FIXME style