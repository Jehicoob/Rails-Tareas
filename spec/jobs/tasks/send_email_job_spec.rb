require 'rails_helper'

RSpec.describe Tasks::SendEmailJob, type: :job do
  # pending "add some examples to (or delete) #{__FILE__}"

  describe "#perform_async" do
    let(:task_id) { "1" } # SendEmailJob necesitamos un id 

    it "sends the email" do
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
