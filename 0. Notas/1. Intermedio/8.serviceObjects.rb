Refactorizar y tener buenas practicas

Modelo - Vista - Controlador

La logica NO va en los [controladores] ni en los [moldeos]

Inyeccionde dependencias ("cajas negras" dentro de "cajas negras")

Service Object -> enmsacarador -> contenedor de sistemas de codigo -> se puede invocar el el controlador, vistas, helpers, etc

- Portable
- Re-usable
- No depende de su estado
- Deterministico
- Unica responsabilidad (SU CODIGO NO DEBE SER MUY EXTENSO)
- Habilita la composicion (DI) (Una sola formade llamarlo y una salida muy bien definida que le dara una uniformidad)
- Interface de acceso uniforme
- GEstion de excepcion
- Respuestas normalizadas

Como se crean: 

Implementando TDD primero se crearon las pruebas

spec/services/tasks/send_email_spec.rb

Para crear el archivo, creamos un nuevo directorio  app/services/tasks/send_email.rb

Nuestro servicio es una clase a lacual le debemos pasar el llamado a la tarea

#send-email
class Tasks::SendEmail

    def call(task) #se recibe la tarea enviada con self

        (task.participants + [task.owner]).each do |user|
            ParticipantMailer.with(user:, task: task).new_task_email.deliver!
        end

    rescue => e  # Barrera por si algo falla - NO ES BUENA PRACTICA

    end
end

#task-model
def send_email
    return unless Rails.env.development?
    Tasks::SendEmail.new.call self #se le pasa la tarea con sefl
end

Agregamos la configuracion de correo de config/environments/development.rb del ActionMailer a config/environments/test.rb

config.action_mailer.default_url_options = { host: 'localhost:3000' }









