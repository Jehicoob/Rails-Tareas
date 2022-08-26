El objetivo del mail es notificar de que una tarea a sido creada

rails g mailer ParticipantMailer

en el archivo participant_mailer.rb creamos lo siguiente:

Un metodo va a aestar referenciado a una vista que va renderizar el email

Se usa elmetodo params para acceder a una informacion que se ha precedido internamente y quetiene la referencia 
a user y task

def new_task_email
    @user = params[:user]
    @task = params[:task]
    mail to: @user.email, subject: 'Tarea Asignada'
end

# ! Como se va a llamar a participantMailer ? y asi poder crear el correo

La idea es que cuando una nueva tarea se cree este pueda llamar al participant mailer 

En el archivo task.rb creamos un callback que nos permita eso

# ! Callback mailer
after_create :send_email

def send_email
    (participants + [owner]).each do |user|
      ParticipantMailer.with(user: user,task: self).new_task_email.deliver!   
    end
  end

usando la palabra clave self voy a acceder a la referencia de esa tarea "la tarea misma "

Despues de ejecutar nuestro metodo necesitamos pasar la visualizacion:

new_task_email

para asegurar que el correo se envie podemos utilizar .deliver!

En la carpeta vistas creada del mailer creamos:

new_task_email.html.haml 

y el template quedaria:

%h1
    hola
    = @user.email
    , tienes una nueva tarea.
%p
    %b Nombre
    = @task.name
%p
    %b Descripcion
    = @task.descrption
%p
    %b Categoria
    = @task.category.name
%p
    %b Enlace
    = task_path @task.code, @task

Luego para hacer pruebas de PRE-Visulaizacion añadimos una gema:

gem 'letter_opener'

en el archivo development.rb debemosconfigurar las acciones del accion_mailer

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.default_url_options = { host: 'localhost:3000' }
  config.action_mailer.perform_caching = false
  config.action_mailer.perform_deliveries = true
  config.action_mailer.delivery_method = :letter_opener
