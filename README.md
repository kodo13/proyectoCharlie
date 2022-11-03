# Proyecto Charlie- Servidor web con Apache- PHP

## Planificación del proyecto
Antes de nada, vamos a git y creamos un nuevo repositorio. Después de esto, creamos nuestro nuevo proyecto en el Code.
Una vez listo esto, creamos también un nuevo proyecto en Git y lo asociamos al repositorio creado anteriormente. Lo creamos en modo board ya que es más visual. 

Después de esto, para llevar un control de todo el proyecto, creamos un planificación con todas las tareas necesarias para llevar el proyecto a cabo. Estas tienen que ser cortas y concretas para hacerlo más sencillo de seguir.

## Tareas
Primero creamos el árbol de directorios que creemos que vamos a necesitar.
***
Una vez listo, buscaremos documentación de las imágenes necesarias.

Buscamos en docker-hub. Vemos que la imagen de httpd no viene con PHP, para tener una imagen con PHP nos redirige a la imagen de PHP - Apache.

[Imagen PHP - Apache](https://hub.docker.com/_/php)
>Enlace a la imagen PHP con Apache.

```
$ docker run -d -p 80:80 --name my-apache-php-app -v "$PWD":/var/www/html php:7.2-apache
```

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
***

Como vamos a usar un navegador web, mapeamos el puerto 80 al 80 del host.

Seguido, mapeamos la configuración de Apache en un nuevo volumen.

[DocumentRoot](https://httpd.apache.org/docs/2.4/mod/core.html#documentroot)
> Documentación para saber el correcto mapeo.

Por defecto, el servidor Apache muestra el contenido de /var/www/html/. Entoces, mapeamos el volumen de nuestra carpeta html a este directorio. Para que veamos si funciona, creamos un index.html con un "Hola mundo", que es lo que se se abre por defecto al acceder.

 Ahora, para tener el volumen independiente al contenedor, lo que hacemos es abrir el volumen en una nueva ventana y descargar toda la configuración de este, guardándola en un directorio nuestro llamado confApache. Después, tenemos que cambiar el mapeo a nuestro directorio con toda la configuración.
***

Accedemos a un navegador, a la dirrección de ***localhost***, y podremos ver el contenido de nuestro index.html.

![(Imagen)](https://github.com/kodo13/proyectoCharlie/blob/main/pictures/Captura%20desde%202022-11-03%2016-35-19.png?raw=true)

>Comprobación de funcionamiento del servidor y visualización página html.

Para ver un PHP en el localhost, creamos un fichero con extensión .php en la misma carpeta html.

```
<?php 

    echo "Hola mundo!";
    phpinfo();

?>
```
***
Ahora, para visualizar esto, como por defecto muestra el index.html, tenemos que indicar la url completa al fichero php.

![(Imagen)](https://github.com/kodo13/proyectoCharlie/blob/main/pictures/Captura%20desde%202022-11-03%2017-21-37.png?raw=true)

>Visualización de funcionamiento del módulo PHP, mostrando PHPinfo.

