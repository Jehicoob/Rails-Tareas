Un problema de la notificaciones por correo electronico es el comportamiento bloqueante se puede obtener, esto se genera cuandouna tarea se queda esperando 
a que todo otro proceso termine, ya que los servidores tienen un tiempo de espera muy grande y en caso de queno resulte nos generara un error.

#! BACKGROUND JOBS  

SE ASOCIAN A PROCESAMIENTO CONCURRENTE O EN PARALELO.

Rails provee el ActiveJob sin embargo este no tiene un backend que lo respalde, por el contrario se necesita asociarlo a otro tipo de librerias para 
poder utilizar completamente el procesoen background que provee rails (sucker_punch).

sucker_punch -> permite utilizar procesos en background y solamente en mi memoria.

Se utilizara unicamente [sucker_punch]

https://github.com/brandonhilkert/sucker_punch

gem "sucker_punch" # Permite realizar los procesos en background

Para ejecutarlo:

#! rails g sucker_punch:job tasks/send_email
                        (namespace/nombre)

create  app/jobs/tasks/send_email_job.rb

Lo que haremoses dejar el llamado al service enviar email a cargo del job

# send_email_job.rb
class Tasks::SendEmailJob
    include SuckerPunch::Job
  
    def perform(task_id) #Lo mejor es recibir tipos de datos planos
      task = Task.find(task_id)
      Tasks::SendEmail.new.call task
    end
end

# task.rb
def send_email
    return unless Rails.env.development?
    # Tasks::SendEmailJob.perform_async self.id.to_s # id.to_s - perform_async -> Espera hasta que sea enviada no importa el tiempo
    Tasks::SendEmailJob.perform_in 5, self.id.to_s # perform_in 5 -> Espera 5 segundos para enviar el correo 
end

#! PRUEBA (TEST)

Pruebas de tipo #* double

double se usa para probar que se esten llamando metodos 

Agregamos a rails_helper.rb

require 'sucker_punch/testing/inline' # Pruebas double

sucker_punch no provee interaccion con rspec entonces paragenerar el archivo:

rails g rspec:job tasks/send_email

create  spec/jobs/tasks/send_email_job_spec.rb

# send_email_job_spec.rb
require 'rails_helper'

RSpec.describe Tasks::SendEmailJob, type: :job do
  # pending "add some examples to (or delete) #{__FILE__}"

  describe "#perform_async" do
    let(:task_id) { "1" } # SendEmailJob necesitamos un id 

    it "sends the email", focus: true do
      # Como el SendEmail ya esta probado no necesitamos probarlo nuevamente, se haran pruebas en fallos
      # cada que una persona utilice Task no va a usar la task real comoclase sino que va a usar la clase falsa
      task = class_double("Task").as_stubbed_const
      service = double # se especificaque el servicio sea falso servicio = Tasks::SendEmail
      object_double("Tasks::SendEmail", new: service).as_stubbed_const # Tasks::SendEmail.new

      expect(task).to receive(:find).with(task_id) # esperamos que el task se invoque conel metodo .find y que reciba el task.id
      expect(service).to receive(:call) # esperamos que el service se invoque conel metodo .call

      described_class.perform_async task_id # ejecutamos el servicio mismo
      
    end

  end

end




