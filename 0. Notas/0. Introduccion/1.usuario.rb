gem "devise"

bundle install

rails g devise:install

create  config/initializers/devise.rb
create  config/locales/devise.en.yml

Se crea un modelo con el devise

rails g devise User 

create    db/migrate/20220808175629_devise_create_users.rb
create    app/models/user.rb
insert    app/models/user.rb
route  devise_for :users

user.rb => Muestra los modulos o funcionalidades de User

en application_controller.rb colocamos para habiltiar la autenticacion 

before_action :authenticate_user! # call back de inicio desesion

Agregarmos boton en el layout principal ( application.html.erb ) para poder cerrar la sesion

<%= link_to 'cerrar sesion', destroy_user_session_path %> <%# opcional method :delete %> => genera error si el metodo no es get

# ! Enlazar usuario a una tarea (Llave foranea)

rails g migration AddOwnerToTask user:references 

En el archivo de migraciones recien creado verificamos que tenga la siguiente estructura:

class AddOwnerToTask < ActiveRecord::Migration[7.0]
    def change
      add_reference :tasks, :owner, null: false, foreign_key: { to_table: :users }, index: true
    end #                  Pertenece a              Cual sera la llave foranea
end

Para asignar la tarea al usuario vamos al archivo task.rb y Agregarmos

belongs_to :owner, class_name: "User"

Y para indicar que a un usuario lepertenece una tarea en el archivo user.rb Agregarmos

has_many :tasks

finalmente se ejecuta elcomando 

rails db:migrate


