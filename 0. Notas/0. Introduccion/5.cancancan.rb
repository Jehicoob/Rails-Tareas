
gem 'cancancan' 

# ! Puede generar conflictos con el precargador de aplicaciones de otras gemas en este caso spring

Nos permite verificar internamente si una persona esapta para acceder auna funcionalidad o no.

rails g cancan:ability -> se guarda en la carpeta models/ability.rb

can :manage, Task, owner_id: user.id 

can -> palabra clave

:manage -> puede acceder a todo

owner_id: user.id -> solo puede acceder a las configuraciones de la task los propietarios de la tarea
#se configura como llave foranea

# -> tambien se configura en el controlador del Task ya que se necesita un putno intermedio donde ejecurtar el cancan

load_and_authorize_resource # ! Vinculamos el Ability del Cancan

Todo lo que este asociado a Task en el hability se va a asumir como reglas de acceso a ese controlador

# * Cuando se realizan estas excepciones es posible generar algunos mensajes de error propios del cancan, se realiza la
# * configuracion de la respectiva accion desde el application_controller:

# Error message: CanCan::AccessDenied

rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path # se redirecciona al path principal 
end

# ! Evitar que la lista salga con recursos que no puede gestionar ese usuario

En el controlador tasks la variable de instancia que parametriza la lista es @tasks por lo que
a ella debenmos hacerle la configuracion

@tasks = Task.all

se realiza la configuracion para que haga el filtrado y muestre las tareas que creo y de las cuales hace parte 

@tasks = Task.joins(:participants).where(
    'owner_id = ? OR participants.user_id = ?', 
    current_user.id, 
    current_user.id
  ).group(:id)

  owner_id = ? -> Si la tarea le pertenece a nuestro usuario se puede mostrar
  participants.user_id = ? -> Si encontramos una asociacionde participantes
  ? -> en ambos casos es current_user.id
  group(:id) -> Evita los resultados duplicados


# ! Permitir solo lectura de una tarea a un participante

En el archivo del cancan -> ability.rb

can :read, Task, participating_users: { user_id: user.id }
