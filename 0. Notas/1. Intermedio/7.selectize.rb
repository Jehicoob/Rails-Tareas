# ! Mejora para los selects

Transforma los selects tradicionales y los mejora

para esto utilizamos el comando

yarn add selectize

en este caso -> yarn add selectize@0.12.6

Una vez instalado lo importamos en el archivo application.js:

import "selectize";

Sin embargo encontraremos problemas en el sistemas de visualizacion con el bootstrap.

Para vincularel selectize con nuestras vistas: 

misc:
  selectizeByScope: (selector) =>
    $(selector).find(".selectize").each (i, el) =>
      $(el).selectize()
    return

Esto itera cada elemento dela vista y el elemento quetemga la clase selectize llama la funcion selectize y los convierte

Para hacer que esta funcion se llame al inicio de la aplicacion:

init: =>
  console.log 'Make with love by Platzi'
  PLATZI.misc.selectizeByScope("body")
  return

Para haceruna prueba vamos a tasks/_form.html.haml

input_html: { class: "selectize" }

.col-sm-3
    = f.input :category_id, label: 'Categoría', as: :select, collection: Category.all, input_html: { class: "selectize" }

Sin embargo esto tiene ciertos problemas visuales, porloque se debe agregar lo siguiente:

Copiamos el contenido del enlace: https://raw.githubusercontent.com/const-se/selectize-bootstrap4-theme/master/dist/css/selectize.bootstrap4.css

Y creamosun nuevo archivoen src/stylesheets/selectize.bootstrap4.css y pegamos ahi el contenidos

Luego lo importamos en el application.sass que esta en la misma carpeta: @import "./selectize.bootstrap4"

#! SELECTIZE CON FORMULARIOS ANIDADOS

Debemos recordar que los elementos para agregar participante estan siendo agregados o construido por simple_form y cocoon.

PARA REALIZAR ESTA FUNCION DEBEMOS ENCONTRAR LA MANERA DE RECIBIR UN EVENTO o callback QUE NOS permita saber cuando hemos insertado un nuevo archivo.

Una ventaja es que COCOON ya hace esto.

Loue se busca hacer es que antes que se renderize "Selectizar" tanto usuario como rol por loque necesitamos es un [before_insert] //Ver Documentacion/Callbacks

Nos dirigimos al main.coffee parainsertar el javascript correspondiente

tasks:
  index:
    setup: =>
      console.log 'In the index page'
      return
  form:
    setup: =>
      $('.participants').on 'cocoon:before-insert', (e, insertedItem, originalEvent) => 
      PLATZI.misc.selectizeByScope insertedItem
      return

insertedItem -> todoel html que va a renderizar

Por lo que podemos usar el PLATZI.misc.selectizeByScope() para que selectize todo lo que esta dentro que contenga la clase selectize 

Este evento solo va a ocurrir cuando alguien oprima el boton de "agregar participante"

agregamos el html a los select correspondientes input_html: { class: "selectize" } del archivo _Participating_user...

.col-4
= f.input :user_id, label: 'Usuario', as: :select, collection: User.all - [current_user], label_method: -> (u) { u.email }, input_html: { class: "selectize" }
.col-4
= f.input :role, label: 'Rol', as: :select, collection: Participant.roles, value_method: -> (r) { r[1] }, input_html: { class: "selectize" }

Una vez hecho esto debemos agregar el llamado al JS en el archivo padre tasks/_form.html.haml

:javascript 
  PLATZI.tasks.form.setup()

Lo que indicaque una vez secargue el documento se va ahacer el llamado a la funcion.


#! CORRIGIENDO FALLOS DE TEST

*Se ejecuta rspec

Una vez realizados estos cambios se deben hacer unas configuraciones de los test debido a que al implementar el selectize "cambia o oculta" los elementos
del select por lo que ya no es tan compatiblecon el [capybara]

Nos da el error en la linea:

# select(category.name, from: 'task[category_id]') #Falla al agregar el selectize

del archivo system/tasks_spec.rb

Para dar solucion a esto debemos agregar un script:

page.execute_script(
    "document.getElementById('task_category_id').selectize.setValue('#{categori.id}')"
)

Le pasamos el id del elemento contenedor de la lista desplegable, accedemos a la propiedad selectize y colocamos el valor id de
la categoria generada previamente.

Corregimos el error igualmente ellos select del formulario deagregar participante 

EN este caso no funciona por id debido a que se le asigna un numero aleatorio, porlo que lo haremos por clase:

En el archivo _participating_user_fields.html.haml

agregamos ls clases "responsible" y "role" y en el test es JS

= f.input :user_id, label: 'Usuario', as: :select, collection: User.all - [current_user], label_method: -> (u) { u.email }, input_html: { class: "selectize responsible" }
= f.input :role, label: 'Rol', as: :select, collection: Participant.roles, value_method: -> (r) { r[1] }, input_html: { class: "selectize role" }

page.execute_script(
    "document.querySelector('.selectize.responsible').selectize.setValue('#{participant.id}')"
)
page.execute_script(
  "document.querySelector('.selectize.role').selectize.setValue('#{1}')"
)









