Es un explorador que esta corriendo sin su depliegue grafico, es decir que funciona sin que nos muestre una impresion grafica.

para utilizar eso en rails necesitamos un sistema que nos permita hablar ese lenguaje. (capybara)

La conexion enre estas dos cosas nos la permite el Driver

rspec + capybara


Utilizamos el generador :

rails g rspec:system task

spec/system/tasks_spec.rb


Nos centramos en el DSL del GitHubde capybara

Para poder utilizar el capybra necesitamos el interprete ocomunicador en este caso usaremos:

gem "selenium-driver"

Adicional a esto debemos adicionar los helpers para pruebas de tipo system

config.include Devise::Test::IntegrationHelpers, type: "system" # Mantener sesion iniciada para system

RSpec.describe "Tasks", type: :system do

    let(:user) { create :user }
    before(:each) { sign_in user }
  
    before do
      driven_by(:rack_test)
    end
  
    describe "GET /tasks" do
      
      it "has a correct title" do
        
        visit "/tasks"
        expect(page).to have_content "Tasks"
  
      end
  
    end
  
    describe "POST /tasks/new" do
  
      let!(:category) { create :category } # no espera a que sea llamado para crearse 
      
      it "has a correct interaction" do
        
        visit "/tasks/new"
  
        fill_in('task[name]', with: 'Test 2')
        fill_in('task[description]', with: 'Mi desc')
        fill_in('task[due_date]', with: Date.today + 5.days)
  
        select(category.name, from: 'task[category_id]')
  
      end
  
    end
  
  end

#! Headless browser con comportamientos dinamicos de JS dentro del HTML
(Pruebas con comportamientos dinamicos)

Una vez configuradas las pruebas "estaticas" necesitamos realizar ls pruebas cuando seoprimeel boton de agregar participante.

Para ver el comportamiento del htmlcuando se oprime el boton utilizamos binding.pry que es un debugger

Vemos que al presionarel boton no se afecta el html debido a que no elmetodo utilizado actualmente no acepta 
comportamientos dinamicos. (:rack_test)

para estovamos al rails_helper y configuramos:

  # JS Off
  config.before(:each, type: :system) do
    driven_by(:rack_test)
  end

  # JS On
  config.before(:each, type: :system, js: true) do
    driven_by(:selenium_chrome_headless)
  end

Sin embargo para que el chrome headless funcione debemos instalar el chromedriver

descarga: https://chromedriver.chromium.org/downloads

unzip chromedriver_linux64.zip 
sudo cp chromedriver /usr/bin 

Le especificamos al it que ejecutara el js el js: true 

it "has a correct interaction", js: true do

De este modo le especificamos que no vamos a usar el :rack_test, sino el :selenium_chrome_headless

Eliminamos el del archivo system/tasks_spec.rb

before do
    driven_by(:rack_test)
end

debido a que ya lo definimos en el rails helper

Una vez hecho esto re-debugueamos 

Comprobado que recibimos lo que esperamos en el debugueo, quitamos el binding.pry

Sin embargo, necesitamos interactuar con el nuevo sistema grafico cuando se busca añadir un participante, por lo que necesitamos
llegar al formulario de forma inequivoca e interactuarcon los selects nuevos, en este caso solo lo haremos con uno solo.

Paraestocopiamosel xpath del componente que lo contiene "//*[@id="addParticipants"]/div/div[1]"

Y usamos el scoping que provee el DSL del capybara paraque a partir de un selector llegue a todo lo que esta dentro de el

xpath = '//*[@id="addParticipants"]/div/div[1]'

within(:xpath, xpath) do
  select(participant.email, from: 'Usuario') # Se seleccionan valor de email
  select("responsible", from: 'Rol') 
end

click_button "Crear Task"

expect(page).to have_content('Task was successfully created.') # se valida que la pagina contenga el texto