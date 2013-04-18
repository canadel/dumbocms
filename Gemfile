if RUBY_VERSION =~ /1.9/
  Encoding.default_external = Encoding::UTF_8
  Encoding.default_internal = Encoding::UTF_8
end

source 'https://rubygems.org'

gem 'sqlite3-ruby', '1.2.5', require: 'sqlite3'

gem 'rails', '3.0.20'
gem 'rake', '0.9.2'
gem 'mysql2', '< 0.3'

gem 'facets', '2.9.2'
gem 'paper_trail', '~> 2'

gem 'bcrypt-ruby', '2.1.4'

gem 'simplest_auth', '0.2.10'
gem 'cancan', '1.6.5'
gem 'ckeditor', '3.6.1'
gem 'rails_admin', path: 'vendor/gems/rails_admin'
gem 'whenever', '0.7.0'
gem 'fog', '0.8.2'
gem 'carrierwave', '0.5.7'
gem 'formtastic', '1.2'
gem 'aasm', path: 'vendor/gems/aasm' # v2.3.0
gem 'paperclip', path: 'vendor/gems/paperclip' # v2.4.0

gem 'liquid', '2.2.2'
gem 'RedCloth', '4.2.8'
gem 'bluecloth', '2.1.0'
gem 'inherited_resources', '1.3.0'
gem 'permalink_fu', '1.0.0'
gem 'sanitize', '2.0.2'
gem 'unicorn'
gem 'haml'

gem 'capistrano'
gem 'capistrano-ext'
gem 'capistrano-unicorn'

gem 'newrelic_rpm'

group :production do
  gem 'rb-readline', '0.4.1'
end

group :development, :test do
  gem 'ruby-debug19', '0.11.6'
  gem 'mocha', '0.9.12'
  gem 'factory_girl', '2.6.1'
  gem 'factory_girl_rails', '1.7.0'
  gem 'faker', '1.0.1'
  gem 'shoulda'
end
