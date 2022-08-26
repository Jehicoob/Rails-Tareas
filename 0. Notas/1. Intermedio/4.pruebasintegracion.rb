agragamos gema en test:

gem "rails-controller-testing"

utilizamos el generador: ( en este caso con el modelo task )

rails g rspec:request task - ejecutamos bi

Nos creara: 

create  spec/requests/tasks_spec.rb

Establecemos una direccion de prueba la cualnos lleva a la creacion de una tarea

describe "GET /tasks/new" do
    it "works! (now write some real specs)" do
      get new_task_path # se ve con el comando rails routes
      expect(response).to render_template(:new)
    end
end

la cual nos da el error de redireccionamiento a la pestaña de log-in

2) Tasks GET /tasks/new works! (now write some real specs)
    #! Failure/Error: expect(response).to render_template(:new)
        #! expecting <"new"> but was a redirect to <http://www.example.com/users/sign_in>
    #* ./spec/requests/tasks_spec.rb:14:in `block (3 levels) in <main>'

para solucionar esto debemos garantizarque antes de ejecutar todas las peticiones el usuario haya iniciado sesion, paraesto vamos al archivo rails_helper y 
incluimos el helper de pruebas de devise llamado : IntegrationHelpers de tipo request

config.include Devise::Test::IntegrationHelpers, type: "request"

en tasks_spec debemos definir un usuario para que exista una sesion: 

primero creamos un usuario
let(:user) { create :user }

ahora necesitamos que ese usuario inicie sesion antes de cada prueba
before(:each) { sing_in user }

probamos usando el comando rspec nuevamente



export RUBYOPT='-W:no-deprecated -W:no-experimental' -> Ocultar mensajes raros xd

#! CREAR UNA TAREA Y PROBAR SU CREACION USANDO PRUEBAS DE PETICION

  describe "POST /tasks" do
    let(:category) { create :category }
    let(:participant) { create :user }
    let(:params) do
      {
        "task"=>{
          "name"=>"test 7",
          "due_date"=> Date.today + 5.days,
          "category_id"=> category.id.to_s,
          "description"=>"test",
          "participating_users_attributes" => {
            "0"=>{
              "user_id"=> participant.id.to_s,
              "role"=>"1",
              "_destroy"=>"false"
            }
          }
        }
      }
    end

    it "creates a new task and redirect to show page" do

      post "/tasks", params: params
      
      # :task = @task -> tasks_controller.rb/create
      expect(response).to redirect_to(assigns(:task))
      follow_redirect!
      expect(response).to render_template(:show)
      expect(response.body).to include('Task was successfully created.')  

    end