Construyendo datos fabrica 

#! Para crear categorias

rails g factory_bot:model category

creara el archivo:

create  spec/factories/categories.rb

#! Para crear usuario

rails g factory_bot:model user

create  spec/factories/users.rb

#! Para crear participante

rails g factory_bot:model participant

create  spec/factories/participants.rb

#! Para crear tareas

rails g factory_bot:model task

create  spec/factories/tasks.rb


#! CREANDO PRUEBA PARA EL MODELO TASK

rails g rspec:model task

Para correr la prueba:

rspec para probar las fabricas




