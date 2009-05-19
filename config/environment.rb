# Be sure to restart your web server when you modify this file.

# Uncomment below to force Rails into production mode when
# you don't control web/app server and can't set it the proper way
# ENV['RAILS_ENV'] ||= 'production'

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.0.2' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence over those specified here

  # Skip frameworks you're not going to use (only works if using vendor/rails)
  # config.frameworks -= [ :action_web_service, :action_mailer ]

  # Only load the plugins named here, by default all plugins in vendor/plugins are loaded
  # config.plugins = %W( exception_notification ssl_requirement )

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )

  # Force all environments to use the same logger level
  # (by default production uses :info, the others :debug)
  # config.log_level = :debug

  config.action_controller.session = {
    :session_key => '_mmlou_session',
    :secret      => 'fbc6a07ca66b503e5aa7d7edd89c6fe68dcd7c7121090d89697554f4e3203b7f0a7cb0e7d171a55c77be8f33e4d62e8d48d72a3b08f13b4556cae93770298e28'
  }
  # Use the database for sessions instead of the file system
  # (create the session table with 'rake db:sessions:create')
  #config.action_controller.session_store = :memory_store

  # Use SQL instead of Active Record's schema dumper when creating the test database.
  # This is necessary if your schema can't be completely dumped by the schema dumper,
  # like if you have constraints or database-specific column types
  # config.active_record.schema_format = :sql

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector

  # Make Active Record use UTC-base instead of local time
  # config.active_record.default_timezone = :utc

  # Add new inflection rules using the following format
  # (all these examples are active by default):
  # Inflector.inflections do |inflect|
  #   inflect.plural /^(ox)$/i, '\1en'
  #   inflect.singular /^(ox)en/i, '\1'
  #   inflect.irregular 'person', 'people'
  #   inflect.uncountable %w( fish sheep )
  # end
  
  # See Rails::Configuration for more options
  
  config.load_paths += %W(#{RAILS_ROOT}/app/sweepers)
  
  # SMTP server configuration
  config.action_mailer.smtp_settings = {
    :address => "smtp.gmail.com",
    :port => 587,
    :domain => "mmlou.com",
    :authentication => :plain,
    :user_name => "mmlouwebmaster@gmail.com",
    :password => "13414902",
  }
  config.action_mailer.default_content_type = "text/html"
  config.action_mailer.perform_deliveries = true

  # Tell ActionMailer not to deliver emails to the real world.
  # The :test delivery method accumulates sent emails in the
  # ActionMailer::Base.deliveries array.
  #config.action_mailer.delivery_method = :test
  config.action_mailer.delivery_method = :smtp
end

ActiveRecord::Base.logger = Logger.new("#{RAILS_ROOT}/log/sql/#{RAILS_ENV}.log", "daily") 
ActionController::Base.logger = Logger.new("#{RAILS_ROOT}/log/#{RAILS_ENV}.log", "daily")

# Add new mime types for use in respond_to blocks:
# Mime::Type.register "text/richtext", :rtf
# Mime::Type.register "application/x-mobile", :mobile

# Include your application configuration below
GLoc.set_config :default_language => :zh
GLoc.clear_strings
GLoc.set_kcode
GLoc.load_localized_strings
GLoc.set_config(:raise_string_not_found_errors => false)