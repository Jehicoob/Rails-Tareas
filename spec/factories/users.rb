# spec/factories/users.rb
FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "person#{n}@example.com" }
    password { '123456' }
  end
end

# De igual forma, en la fábrica del usuario estamos usando el sistema de secuenciación del FactoryBot, 
# y también estamos definiendo una contraseña estática con valor 123456