# Proyecto Charlie- Servidor web con Apache- PHP

## Planificación del proyecto
Antes de nada, vamos a git y creamos un nuevo repositorio. Después de esto, creamos nuestro nuevo proyecto en el Code.
Una vez listo esto, creamos también un nuevo proyecto en Git y lo asociamos al repositorio creado anteriormente. Lo creamos en modo board ya que es más visual. 

Después de esto, para llevar un control de todo el proyecto, creamos un planificación con todas las tareas necesarias para llevar el proyecto a cabo. Estas tienen que ser cortas y concretas para hacerlo más sencillo de seguir.

## Tareas
Primero creamos el árbol de directorios que creemos que vamos a necesitar.

Una vez listo, buscaremos documentación de las imágenes necesarias.

Buscamos en docker-hub. Vemos que la imagen de httpd no viene con PHP, para tener una imagen con PHP nos redirige a la imagen de PHP - Apache.

'$ docker run -d -p 80:80 --name my-apache-php-app -v "$PWD":/var/www/html php:7.2-apache'

Este es el código para crear el contenedor. De ahí también sacamos la imagen que tenemos que configurar.

 Como queremos crear un docker-compose, lo que tenemos que hacer es convertir esa línea de código a una configuración de docker-compose.

 ```
version: '3.9'
services:
#Nombre del servicio
  asir_apache-php: 
    container_name: asir_apache
    image: php:7.4-apache
    ports:
      - '80:80'
    volumes:
      - ./html:/var/www/html
      - confApache:/etc/apache2 #Al poner el nombre, llamamos al volumen. De esta
      #manera, la configuración nos queda fuera del contenedor.
volumes:
  confApache: #Declaración del volumen, el cual usamos más arriba.
  #Para editar los ficheros, podemos ver los ficheros, haciendo click en  el volumen creado.
#Y seleccionando explore in dev container.

 ```


Como vamos a usar un navegador web, mapeamos el puerto 80 al 80 del host.

Seguido, mapeamos la configuración de Apache en un nuevo volumen. Ahora, para tener el volumen independiente al contenedor, lo que hacemos es abrir el volumen en una nueva ventana y descargar toda la configuración de este, guardándola en un directorio nuestro llamado confApache. Después, tenemos que cambiar el mapeo a nuestro directorio con toda la configuración.
Por defecto, el servidor Apache muestra el contenido de /var/www/html/. Entoces, mapeamos el volumen de nuestra carpeta html a este directorio. Para que veamos si funciona, creamos un index.html con un "Hola mundo", que es lo que se se abre por defecto al acceder.

De esta manera, accedemos a un navegador, a la dirrección de ***localhost***, y se nos podremos ver el contenido de nuestro index.html.

