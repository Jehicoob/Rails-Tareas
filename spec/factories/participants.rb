# spec/factories/participants.rb
FactoryBot.define do
  factory :participant do

    association :user

    trait :responsible do
      role { Participant::ROLES[:responsible] }
    end

    trait :follower do
      role { Participant::ROLES[:follower] }
    end
  
    after(:build) do |participant, _|
      participant.user.save
    end

  end
end


# En esta fábrica hemos añadido tres elementos importantes, el sistema de asociación, el sistema de rasgos (traits) y el sistema de 
# callbacks.

# Con la definición del método association FactoryBot de forma automática buscará la fábrica de Usuarios para construir el registro 
# de usuario y asociarlo al registro de participante.

# Con los rasgos, podemos de forma semántica definir al momento de invocar la fábrica si queremos que el participante tenga una 
# condición específica, en este caso, que su rol sea responsable o seguidor.

# Finalmente, con el sistema de callbacks, podemos ejecutar una o varias operaciones cuando el proceso de creación o construcción 
# empiece o termine, en nuestro ejemplo, ejecutaremos el proceso participant.user.save cuando el registro participant termine de 
# construirse asegurando que el registro de usuario si sea persistido.