Creamos un nuevo grupo para realizar los test

EN mongo NO se utilizan sistemas transaccionales es decir, no hay rollbacks o commits de cierto tipo de agrupaciones dentro de 
un proceso de base de datos

1- Cada vez que ejecutamos una prueba necesitamos que los registros se eliminen #! database_cleaner
  #! Las ultimas versiones de mongo ya trae este conceptode transaccionalidad.
2- Necesitamos generar informacion falsa #! faker

group :test do
    gem "database_cleaner" # Controlar estado de nuestra base de datos en registros 
    gem "faker" # Generar informacion falsa
    gem "capybara" # Interacciones con el explorador
end

Agregamos en el grupo :development, :test do
    gem "rspec-rails" #! Gema que nos permite hacer pruebas 
    gem "factory_bot_rails" # Permite hacer fabricas automaticas de instanciasde mis modelos,
    # podremos crear categorias, participantes,tareas, usuario de forma automatica
end

Ejecutamos el generador de rspec #! rails g rspec:install

Este nos generara 2 archivos de configuracion para establecer la linea base de las pruebas

    create  .rspec
    create  spec
    create  spec/spec_helper.rb #
    create  spec/rails_helper.rb #

En el archivo [spec_helper.rb] buscamos las siguientes lineas

config.filter_run_when_matching :focus

Es muy importante cualdo se tienen muchas pruebas y no se quieren correr todas las pruebas sino solamente 1 sola

config.default_formatter = "doc" 

Al tener el default formater en "doc" conseguimos que las respuestas sean mas expresivas enel resultado final

En el archivo [rails_helper.rb] buscamos las siguientes lineas

Importamos cada libreria que hemso descargado desde el gemfile
require 'factory_bot_rails'
require 'database_cleaner', "~> 1.99"
require 'capybara/rails'

Desactivamos los sistemas transaccionales descomentando la siguiente lineay colocandola en false

config.use_transactional_fixtures = false


config.infer_spec_type_from_file_location! -> como vamos a utilizar varios tipos de pruebas siguiendo la convencion de nobramiento de 
los directorios vamos a encontrar que de forma automaticael sistema va a proveer de cierto tipo de metodos a las pruebas. 

config.filter_rails_from_backtrace! -> Si hay algun tipo de error dentro de las pruebas, el va a ocultar todas las lineas del backtrace 
que no esten relacionadas con mi prueba y que esten relacionadas a librerias del core de rails



