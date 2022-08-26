Gestorde versiones de MongoDB ( M )

npm install -g m

mkdir -p servers/mongodb/bin -> Donde vamos a guardar los binarios de nuestro sistemas de bases de datos.
mkdir -p data/mongodb/4.2 -> Donde vamos a almacenar nuestros datos o nuestras bases de datos (usar una carpeta por version de mongo)

echo 'export M_PREFIX=~/servers/mongodb' >> ~/.zshrc -> Prefijamos una variable en la shell donde apuntamosa una variable de entorno
llamada m-prefix, nos indica que en /servers/mongodb encontraremos los binarios y la instalacion de la libreria m que nos ayudara
como gestor deversiones de mongo.

para ver las versiones disponibles se usa #!: m ls

En este caso se utiliza la 4.2.7 #!: m 4.2.7

Para definir que la estamos usando lo hacemos con el comando  #! m use (version) --dbpath ~/data/mongodb/(version)

#! m use 4.2.7 --dbpath ~/data/mongodb/4.2 

Para ingresar al cliente de mongo DB: #! m shell (version)

#! m shell 4.2.7

Para ver las bases de datos actuales usamos: 

#! show dbs

Para ver los directorios en la carpeta servers: #! servers/mongodb/bin

#! bin ls -la -> para verlos mas ordenados

Comentamos las siguientes lineas en application.rb

# require 'active_record/railtie' # ActiveRecord -> Postgresql
# require 'active_storage/engine' # -> tiene relacion con active record
# require 'action_mailbox/engine' # -> tiene relacion con active record
# require 'action_text/engine' # -> tiene relacion con active record

#! eliminamos el archivo database.yml yaque esta configurado para postgresql no para mongodb

#! Editamos los archivos que tengan relacion o dependencia de active record o active storage

En todos los archivos de config/environment que contengan active_record o active_storage se comenta

Se buscar el archivo devise.rb y se cambia la linea 

require 'devise/orm/active_record' por #! require 'devise/orm/mongoid'

Vamos a nuestro GemFile:

Retiramos las gemas #! gem 'pg', '>= 0.18', '< 2.0' # gem 'annotate'

En la carpeta app/models/ #! eliminamos el archivo application_record.rb y todas sus dependencias

En mongoid no se usa herencia para establecer establecer la conexion con el driver, se utilizara composicion de modulos.

category: 

cambiamos de:

class Category < ApplicationRecord
    has_many :tasks
    validates :name, :description, presence: true
    validates :name, uniqueness: { case_insensitive: false }
end

a

class Category # Se elimina la dependencia de herencia
    #* Modulos
    include Mongoid::Document # Se coloca la composicion del Modulo Mongoid::Document (Clase)
    include Mongoid::Timestamps # -> Timestamps incluye updated_at y created_at

    #* Campos
    # Se deben definir los capos que hacen falta: 
    field :name, type: String
    field :description, type: String
    
    #* Relaciones
    has_many :tasks

    #* Validaciones
    validates :name, :description, presence: true
    validates :name, uniqueness: { case_insensitive: false }
end


Para añadir los fields a un modelo de forma automatica se puede usar: #! rails g devise user


Crear archivo de configuracion de #! mongoid -> rails g mongoid:config










