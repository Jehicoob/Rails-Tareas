
rails g model Participant role:integer user:references task:references

Como el participante esta en medio del User y el task, creamosrelacionentreello primero en User:

user.rb
# Tareas propias del usuario
has_many :owned_tasks
# participations => Es lo que un usuario esta teniendodentro dela tarea especifica (participaciones)
has_many :participations, class_name: 'Participant'
# Tareas de las cuales de accede por medio de participations con through
has_many :tasks, through: :participations