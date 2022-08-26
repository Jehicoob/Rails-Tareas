# spec/factories/categories.rb
FactoryBot.define do
  factory :category do
    sequence(:name) { |n| "Categoria #{n}" }
    description { Faker::Lorem.sentence }
  end
end


# Lo que estamos haciendo en esta fábrica es automatizar la creación de una categoría con los campos name y description mientras 
# en el name estamos usando un sistema de secuenciación de base de datos propio del FactoryBot para evitar que se creen dos 
# categorías con el mismo nombre, en el campo de descripción estamos usando Faker para generar un texto de tipo Lorem Ipsum de 
# forma aleatoria