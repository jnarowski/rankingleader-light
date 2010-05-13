# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.2' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  # Add additional load paths for your own custom dirs
  config.load_paths += %W( #{RAILS_ROOT}/app/reports )
  config.load_paths += %W( #{RAILS_ROOT}/app/jobs )
  
  # Specify gems that this application depends on and have them installed with rake gems:install
  config.gem "fastercsv"
  config.gem 'bj'
  config.gem 'javan-whenever', :lib => false, :source => 'http://gems.github.com'
  config.gem "calendar_date_select"
   
  # ruport stuff 
  require 'ruport' 
  require 'ruport/acts_as_reportable'
  require 'ftools'
  
  require "#{RAILS_ROOT}/app/reports/standard_pdf_report"
  require "#{RAILS_ROOT}/app/reports/report_helper"
  require "#{RAILS_ROOT}/lib/ruseo/ruseo" 
    
  # Only load the plugins named here, in the order given (default is alphabetical).
  # :all can be used as a placeholder for all plugins not explicitly named
  config.plugins = [ :exception_notification, :all ]
  
  config.action_mailer.smtp_settings = {
      :address => "mail.metaspring.com",
      :authentication => :login,
      :user_name => "mailer@metaspring.com",
      :password => "mailer123",
      :domain => 'metaspring.com'
  }
  
  # Activate observers that should always be running
  config.active_record.observers = :article_observer

  # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
  # Run "rake -D time" for a list of tasks for finding time zone names.
  config.time_zone = 'UTC'
end