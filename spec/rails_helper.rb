# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?

require 'rspec/rails'

#! IMPORTAMOS LIBRERIAS
require 'factory_bot_rails'
require 'database_cleaner' #! ERROR
# require 'database_cleaner/mongoid'
require 'capybara/rails'
require 'mongoid-rspec'
require 'sucker_punch/testing/inline' # Pruebas double

# Add additional requires below this line. Rails is not loaded until this point!

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
#
# The following line is provided for convenience purposes. It has the downside
# of increasing the boot-up time by auto-requiring all files in the support
# directory. Alternatively, in the individual `*_spec.rb` files, manually
# require only the support files necessary.
#
# Dir[Rails.root.join('spec', 'support', '**', '*.rb')].sort.each { |f| require f }

RSpec.configure do |config|
  # Remove this line to enable support for ActiveRecord
  config.use_active_record = false

  # If you enable ActiveRecord support you should unncomment these lines,
  # note if you'd prefer not to run each example within a transaction, you
  # should set use_transactional_fixtures to false.
  #
  # config.fixture_path = "#{::Rails.root}/spec/fixtures"
  
  #! Desactivamos el uso transaccional
  config.use_transactional_fixtures = false

  #!incluimos helpers
  config.include FactoryBot::Syntax::Methods # Metodos del factory bot 
  config.include Warden::Test::Helpers # Helpers de inicio de sesion
  config.include Devise::Test::ControllerHelpers, type: "controller"
  config.include Devise::Test::IntegrationHelpers, type: "request" # Mantener sesion iniciada para request
  config.include Devise::Test::IntegrationHelpers, type: "system" # Mantener sesion iniciada para system

  config.include Mongoid::Matchers, type: :model # junto con el require

  #! Protocolos
  # Antes de ejecutarse la suite o grupo de pruebas establezcamos unas condiciones
  config.before(:suite) do
    #Establecemos que la definicion del database cleaner se haga sobre el ORM
    # DatabaseCleaner.orm = "mongoid" #! ERROR
    # Cada vez que inicie este grupo de pruebas haga un clean a la base de datos
    DatabaseCleaner.clean
    # DatabaseCleaner[:mongoid].strategy = [:deletion]
  end
  
  # Antes de que finalie la prueba
  config.before(:each) do
    DatabaseCleaner.start
  end

  # Despues de que finaliza la prueba
  config.after(:each) do
    DatabaseCleaner.clean
  end
  
  # JS Off
  config.before(:each, type: :system) do
    driven_by(:rack_test)
  end

  Selenium::WebDriver::Chrome::Service.driver_path = "/usr/bin/chromedriver"

  # JS On
  config.before(:each, type: :system, js: true) do
    driven_by(:selenium_chrome_headless)
  end

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     RSpec.describe UsersController, type: :controller do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://relishapp.com/rspec/rspec-rails/docs
  config.infer_spec_type_from_file_location!

  # Filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!
  # arbitrary gems may also be filtered via:
  # config.filter_gems_from_backtrace("gem name")
end
