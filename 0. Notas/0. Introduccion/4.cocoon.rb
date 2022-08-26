Los formularios anidados quieren decir que en un solo formulario haya interacción con dos modelos. En este caso será con Task y Participant, con la ayuda de la gema Cocoon.

Para instalar esta gema hay que agregarla en el Gemfile, lo siguiente es agregar una dependencia de Cocoon para que pueda trabajar de forma correcta, esta dependencia se agrega con yarn desde el siguiente repositorio: github:nathanvda/cocoon#c24ba53.
gem 'cocoon'
yarn add github:nathanvda/cocoon#c24ba53

Configuración de cocoon
En el archivo eviroment.js:

const webpack = require('webpack')

environment.plugins.prepend('Provide',
    new webpack.ProvidePlugin({
        $: 'jquery',
        jQuery: 'jquery',
        'window.jQuery': 'jquery',
        Popper: ['popper.js', 'default'],
    })
)
En el archivo application.js:

import 'cocoon'
Esta configuración es necesaria ya que cocoon tiene como dependencia a jquery.

Una vez hecho esto hacemos la migración, para migrar el modelo Participant (rails db:migrate).

Formulario de tasks
En el formulario de tasks es donde se requiere asociar con los participantes, para esto se usará simple_fields_for, un método que permite asociar un modelo anidado que exista en la estructura de modelos.

= simple_form_for(@task) do |f|
  = f.error_notification
  = f.error_notification message: f.object.errors[:base].to_sentence if f.object.errors[:base].present?

  .form-inputs
    = f.input :name, label: t('tasks.name')
    = f.input :description, label: t('tasks.description')
    = f.input :due_date, label: t('tasks.due_date')
    = f.association :category, label: t('tasks.category')
    
    .participants
      = f.simple_fields_for :paticipating_users

Con el método simple_fields_for se habilita la comunicación con participating_users, que es como se nombró la relación entre tareas y participantes.

Para el formulario principal el constructor es f (primera línea) y para el formulario anidado el constructor es g.

Para presentar el formulario anidado se usará un parcial, que es un archivo creado en la carpeta views>tasks con el nombre _participating_user_fields.html.haml. Y se llamará al formulario principal con la función render dentro del formulario anidado.

.participants
      = f.simple_fields_for :paticipating_users
        = render 'participating_users_fields', f: g

        Parcial:

.nested-fields 
    = f.input :user_id, as: :select, collections: User.all - [current_user]
    = f.input :role
En el primer input se inserta un elemento select, para poder elegir entre todos los usuarios, pero le restamos el usuario actual para que no aparezca en la lista. Era necesario poner current_user en un arreglo para que Ruby pudiera realizar las operaciones entre arreglos con User.all (también es un arreglo) sin problemas.