Tecnologia "Antigua" pero que aun se usa en algunos proyectos 

Metalenguaje quenospermite optimizar nuestro procesode codificacion

Permite consolidar informacion en un archivo elcual llamaremos cuando necesitemos logica especifica

Para instalarlo debemos ejecutar: rails webpacker:install:coffee #* NO ME FUNCIONO

#!ERROR DE COFFEE-LOADER

npm install --save-dev coffeescript coffee-loader #! 

npm install --save-dev coffeescript@1.12.7 coffee-loader@1.0.0 #* :D Lo instalaen dev obviamente, toca moverlos a "dependencies" enel package.json

Creamosun archivo de consolidacion o una referencia elcual importamos en application.js (#! ACA SE VINCULAN TODOS LOS ARCHIVOS creo xd)

import "../src/javascripts/main";

Creamos el archivo main.coffee y dentro del el establecemos para probar:

#Window -> variable global, PLATZI -> nombre asignado a la variable
window.PLATZI = 
  init: =>
    console.log 'Make with love by Platzi'
    return
$(document).on 'turbolinks:load', () => PLATZI.init()

Este mensaje queda definido para que cada que se cargue una pargina se muestre

Configuracion para una vista unicamente

window.PLATZI = 
  init: =>
    console.log 'Make with love by Platzi'
    return
  tasks:
    index:
      setup: =>
        console.log 'In the index page'
        return

$(document).on 'turbolinks:load', () => PLATZI.init()

En la vista tasks/index.html.haml se agrega:

:javascript
  PLATZI.tasks.index.setup();

lo que realiza el llamado a esa parte en especifico del JS

#! Este archivo nos permite modularizar de ciertamanera logicaque podemos usar en el javascript y nuestro proyecto



