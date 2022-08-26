before_action :authenticate_user! #Solamentelos usuarios registrados pueden ingresar al index de la pag

before_action :set_locale # Lenguaje en español

Le decimos al servido que afecte un momento del ciclo de vida "before_action"

Para realizar una prueba creamos una migracion para generar un numero aleatorio antes de que la tarea (Task) sea grabada

rails g migration addCodeToTask code:string

rails db:migration

en el archivo del modelo task creamos los siguiente


# ! Prueba de callback
before_create :create_code

def create_code
  self.code = "#{owner_id}#{Time.now.to_i.to_s(36)}#{SecureRandom.hex(8)}"
end

con self indicamos que es el estado que representa en ese momento, es decir permite indicar que en ese momento vamos a 
establecer un valor antes de que la tarea sea creada