source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.1.2'

gem 'net-smtp'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails', branch: 'main'
gem 'rails', '~> 6.1.6', '>= 6.1.6.1'

gem 'mongoid', github: 'mongodb/mongoid', branch: "7.5-stable"

# Use postgresql as the database for Active Record
# gem 'pg', '~> 1.1'
# Use Puma as the app server
gem 'puma', '~> 5.0'
# Use SCSS for stylesheets
gem 'sass-rails', '>= 6'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '~> 5.0'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.4', require: false

# gem 'annotate' # Genera informacion de la configuracion de los modelos anottate --models
gem 'hamlit' # Se debe registrar tambien en development
gem 'rails-i18n' # Genera patrones de traduccion de forma automatica (bi con server off)
gem 'simple_form' # Genera estructura de formulario
# gem "i18n-tasks", "~> 0.7.4" # gem install i18n-tasks antes de usar -> i18n-tasks add-missing
# create categoria => crear categoria
gem 'devise' # Autenticacion -> bi -> rails g devise:install -> rails g devise User
# formularios anidados
gem 'cancancan' # rails g cancan:ability -> Limita el acceso de los usuarios
gem 'cocoon' # Formularios anidados (simple_form)
gem 'rubocop'
gem 'rubocop-rails'

gem 'font-awesome-sass', '~> 5.12.0'

gem "sucker_punch" # Permite realizar los procesos en background

gem "aasm"

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'pry' # Perite hacer tests
  gem 'pry-doc' # Perite hacer tests
  gem "rspec-rails" #! 
  gem "factory_bot_rails" #!
  # Permite hacer fabricas automaticas de instanciasde mis modelos,  
  #podremos crear categorias, participantes,tareas, usuario de forma automatica
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 4.1.0'
  # Display performance information such as SQL time and flame graphs for each request in your browser.
  # Can be configured to work on production as well see: https://github.com/MiniProfiler/rack-mini-profiler/blob/master/README.md
  gem 'listen', '~> 3.3'
  gem 'rack-mini-profiler', '~> 2.0'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  # gem 'spring'

  gem 'hamlit-rails'

  gem 'letter_opener' # Gema para testear los correos
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

# Grupo creado para los test
group :test do
    gem "database_cleaner", "~> 1.99" # Controlar estado de nuestra base de datos en registros #!
    # gem "database_cleaner-mongoid" # Controlar estado de nuestra base de datos en registros #!
    gem "faker" # Generar informacion falsa #!
    gem "capybara" # Interacciones con el explorador #!
    gem "mongoid-rspec" # Nos proporciona una suite de pruebas que podemos utilizar para hacer uso de los modelos
    gem "rails-controller-testing" #
    gem "selenium-webdriver"
end


