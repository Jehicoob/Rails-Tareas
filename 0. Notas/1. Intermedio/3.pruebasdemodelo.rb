Añadimoen el grupo creado de :test la gema:

gem "mongoid-rspec"

para crear la prueba del modelo utilizamos:

#! rails g rspec:model (nombreModelo)

ej:
rails g rspec:model Cateogry

genera los archivos:

spec/factories/categories.rb #* Damos n para no modificar este archivo
spec/models/category_spec.rb

El categories ya se edito entonces NO se sobreecribe.

En [category_spec]: va a ser donde colocaremos las pruebas asociadas a cetegory

Para verificar si el archivo de pruebas esta funcionando realizamos lo siguente

RSpec.describe Category, type: :model do
    it { is_expected.to be_mongoid_document }
    it { is_expected.to have_timestamps }
end

Y ejecutamos el comando #! rspec

#TODO: Hacer validaciones del usuario basandonos en category_spec y task_spec

