Es un modelo decomputacion matematicoen cuantos estados y en que estado esta en un momento determinado

Solo se pueden modelar los sistemas finitos

NO solamente se van a tener estados dentro de una maquina de estados, tambien se vana tener procesos o eventos que nos van a hacer transiciones entre estados

Estos eventos suelen venir con desencadenadores o triggers. (ejemplo al confirmar una cita se envie un mensaje de texto)

En este caso usaremos la #! gema AASM


* En que estado o en que parte de su ciclo de vida esta una tarea dentro del sistema *

#* COMENTARIO:
Para la maquina de estados tambien existe una gema bastante chevere llamada [statesman] y para el tema de auditoria hay una gema llamada [audited] que tiene gran 
cantidad de funcionalidades que serviran para otros proyectos.

Se Construira una maquina de estados para el modelo #! task

Agregamos la gema: gem "aasm"

# models/task.rb
Incluimos la gema en el modelo dondese va a usar:

include AASM

Creamos un campo expecifico el cual va a estar en la maquina de estados:

field :status, type: String

Tendremos 3 estados (Pendiente, en proceso y finalizada)

  #AASM Maquina de estado
  aasm column: :status do # se le establece la variable declarada previamente
    state :pending, initial: true
    state :in_process, :finished

    event :start do
      transitions from: :pending, to: :in_process
    end

    event :finish do
      transitions from: :in_process, to: :finished
    end

  end

Para poder ver el estado actual de la tarea podemos hacerlo por medio de la consoa de rails usando rc o rails console: 

Task.first (en el campo status)

o directamente: Task.first.status

Para hacer que persista o cambie de estado debemos hacer:

Task.first.start! Asi pasara de pending a in_process

Si queremos finalizar: Task.first.finish!

#! AUDITAR LOS CAMBIOS EN LAS TRANSICIONES DE ESTADOS

CALLBACKS - DOCUMENTACION

after_all_transitions :log_status_change

Para ayudarnos a persistir los estados creamos un campo quenos mostrara las transiciones realizadas

field :transitions, type: Array, default: []

  #callback
  def audit_status_change
    # puts "changing from #{aasm.from_state} to #{aasm.to_state} (event: #{aasm.current_event})"
    set transitions: transitions.push(
      {
        from_state: aasm.from_state,
        to_state: aasm.to_state,
        current_event: aasm.current_event,
        timestamps: Time.zone.now
      }
    )
  end

al ejecutar por consola: reload!, Task.first.status Vemos que el estado esta en finished, para reiniciarlo: Task.first.set status: "pending"

Iniciamos nuevamente: Task.first.start!

Vemos el estado actual: Task.first.status, el cual es "in_process"

Para ver las tansiciones realizadas: Task.first.transitions

[{  "from_state"=>:pending,                                                             
    "to_state"=>:in_process,                                                            
    "current_event"=>:start!,                                                           
    "timestamps"=>2022-08-26 14:55:33.359 UTC   }]


#! GESTIONAR LOS ESTADOS DESDE AFUERA (SERVICE)

Para esto crearemos un service object empezando por el test

#services/tasks/trigger_event_spec.rb
require 'rails_helper'

RSpec.describe Tasks::TriggerEvent do
  let(:participants_count) { 4 }
  let(:task) { build(:task_with_participants, participants_count: participants_count) }

  subject(:service) { described_class.new }

  describe '#call' do
    context 'with a valid task' do
      before(:each) { task.save }

      let(:event) { "start" }
  
      it 'should return success' do
        success, message = service.call task, event
        expect(success).to eq true
        expect(message).to eq 'successful'
        expect(task.status).to eq "in_process"
        expect(task.transitions.count).to eq 1
      end
    end
  end
end

Una vez realizada la prueba procedemos a realizar el service del Trigger

# services/tasks/trigger_event.rb
class Tasks::TriggerEvent
    def call(task, event)
      
      # security polices
      # access polices
      # connection to another service
  
      task.send "#{event}!" # = task.start!
      [true, 'successful']
    rescue => e
      Rails.logger.error e
      [false, 'failed']
    end
  end


#! CRENDO ACCION DE CONTROLADOR PARA QUE ACTUE CON NUESTRO SERVICE

# app/controller/tasks/tasks_controller.rb

before_action :set_task, only: %i[show edit update destroy trigger]

def trigger
    Tasks::TriggerEvent.new.call @task, params[:event]
end

Agregamos una nueva ruta:

Rails.application.routes.draw do
    devise_for :users
    resources :tasks do
      patch :trigger, on: :member #! editar el estado ola instacia de una tarea
      resources :notes, only: [:create], controller: 'tasks/notes'
    end
    resources :categories
    # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
    root 'tasks#index'
end

Para ver la ruta ya creada desde la consola:

rails routes | grep trigger # para filtrar la ruta solo por trigger 

trigger_task PATCH  /tasks/:id/trigger(.:format)    tasks#trigger

Una vez verificado desde la consola definimos como lo vamosa probar:

Como se esta haciendouna peticion, debemos usar una orueba de peticion, como yatenemos una prueba de peticion de task usamos esa

#spec/request/tasks_spec.rb

describe "PATCH /tasks/:id/trigger" do
    let(:participants_count) { 4 }
    let(:event) { "start" }
    subject(:task) do 
        build(:task_with_participants, owner: user, participants_count: participants_count)
    end

    # Queremos probar que cuando llamemos a la peticion /tasks/:id/trigger nuestra tarea este actualizada enelestado que le fijemos

    it "updates the state" do

      task.save

      patch trigger_task_path(task, event: event)

      expect(task.reload.status).to eq "in_process" 
       
    end

end

Si queremos poder acceder a esta ruta desde la prueba debemos recordar que le damos permisos pasando el usuario como #! owner 

#! INTEGRANDO LA PETICION Y PRUEBAS EN LA INTERFAZ GRAFICA PARAACTUALIZAR EL ESTADO DE UNA TAREA

Agregamos las filas y las columnas nuevas a la vista de show # tasks/show.html.haml

Para mostrar las opciones de estados disponibles para esta tarea, usamos un helpet como ayuda, un helper que genera el scaffold llamado

# tasks_helper.rb

module TasksHelper
    def available_events_for(task)
        task.aasm.permitted_transitions.map { |t| t[:event] }
    end
end

Y como este es un helper de las tareas puede ser llamado en cualquier vista de las tareas

la tabla de tasks/show.html.haml quedaria asi:

%table.table.table-striped.table-borderless
    %thead
        %tr
            %th Código
            %th Nombre
            %th Categoría
            %th Creador
            %th Estado
            %th
    %tbody
        %tr
            %td= @task.code
            %td= @task.name
            %td= @task.category.name
            %td= @task.owner.email
            %td.task_status= @task.status
            %td
                .dropdown
                    %a#taskMenu{"aria-expanded" => "false", "aria-haspopup" => "true", "data-toggle" => "dropdown"}
                        .fas.fa-ellipsis-v
                    .dropdown-menu{"aria-labelledby" => "taskMenu"}
                        - available_events_for(@task).each do |event|
                            = link_to event, trigger_task_path(@task, event: event, format: :js),remote: true, method::patch, class: 'dropdown-item'


Ahoracreamosla vista relacionadaa la accion trigger

en views/tasks/trigger.js.erb donde buscaremos la clase asignada al cambpo variable .task_status

document.querySelector(".task_status").innerHTML = "<%= @task.status %>";
















