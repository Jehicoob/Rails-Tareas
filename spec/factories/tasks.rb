# spec/factories/tasks.rb
FactoryBot.define do
  factory :task do
    sequence(:name) { |n| "Tarea #{n}" }
    sequence(:description) { |n| "Descripcion #{n}" }
    due_date { Date.today + 15.days }
    category
    association :owner, factory: :user
      
    factory :task_with_participants do
      transient do
        participants_count { 5 }
      end
  
      after(:build) do |task, evaluator|
        task.participating_users = build_list(
          :participant,
          evaluator.participants_count,
          task: task,
          role: 1
        )
        
        task.category.save
        task.owner.save
      
      end
    
    end
    
  end
  
end

# A pesar de que parezca complejo, en esta fábrica hemos combinado todos los elementos vistos en las anteriores fábricas y hemos 
# añadido dos conceptos nuevos, el de asociación implícita con la llamada simple al método category y el concepto de fábrica anidada.

# La asociación implícita a través del método category simplemente hace lo mismo que la asociación de usuario en la fábrica de 
# participantes, está creando un registro de categoría de forma automática cuando la tarea se está creando. Por otro lado, hay una 
# declaración explícita de la fábrica de usuario en la relación owner, la cual se comporta de igual forma que una asociación normal 
# pero definiendo que la fábrica a usar será :user

# La fábrica anidada, nos está dando la flexibilidad de complementar los elementos de la fábrica de tareas principal, dotandonos de 
# la capacidad de crear una tarea con participantes, e incluso poder definir el número de participantes en la tarea construida a 
# través del método transient y la declaración de la variable participants_count que más adelante será accedida en el cuerpo de 
# callback desde un elemento de habilitación de transferencia de datos llamado evaluator

# Internamente, en el cuerpo del callback, estamos usando un método de FactoryBot llamado build_list que nos permitirá en un sólo 
# comando crear una lista de registros con una fábrica definida, al final de esta ejecución simplemente estamos persistiendo las 
# asociaciones generadas para el creador de la tarea y la categoría.