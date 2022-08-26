Instalacion de dependencias:

yarn add boostrap jquery popper.js roboto-fontface 


Se ajusta el sistemas de frontend con bootstrap

rails g simple_form:install --bootstrap



rails g scaffold Category name:string description:string

rails g scaffold Task name:string description:text due_date:date category:references



Configuramos el acceso a postgresql

rails db:create

en config/locales/database.yml configuramos en las secciones development y test lo siguiente

host: localhost
user: jehicoob
password: 1980

en category.rb

class Category < ApplicationRecord
    # Se usa la clase tasks para que por convencion sepaque se habla de la clase y/o modelo task
    has_many :tasks
end

Usar la gema "annotate" nos permite tener mas informacion de los datos, en este caso de los modelos

%w() is a "word array" - the elements are delimited by spaces.

There are other % things:

%r() is another way to write a regular expression.

%q() is another way to write a single-quoted string (and can be multi-line, which is useful)

%Q() gives a double-quoted string

%x() is a shell command.