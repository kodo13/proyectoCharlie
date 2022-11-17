
<h1 align="center"> Proyecto Charlie- Servidor web con Apache - PHP </h1>

<p align="left">
   <img src="https://img.shields.io/badge/STATUS-EN%20DESAROLLO-green">
   </p>

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

Para tener el volumen independiente al contenedor, primero lo que hacemos es crear un volumen con lo que queremos mapear, en este caso la configuración de apache2.
A la misma altura que services, tenemos que crear el volumen sobre el cual hemos mapeado la configuración de apache.

Ahora, si queremos tener la configuración en local, podemos ejecutar el comando docker cp, que copia ficheros del contenedor al local o al revés.

` docker cp asir_apache:/etc/apache2 . ` 
> Comando para copiar la configuración en el directorio del proyecto.

Otra manera es abrir en una nueva ventana del volumen y descargar uno por uno cada directorio y guardarlo en el directorio local.


![(Imagen)](https://github.com/kodo13/proyectoCharlie/blob/main/pictures/Captura%20desde%202022-11-03%2016-39-45.png?raw=true)


Después, tenemos que cambiar que en vez de utilizar el volumen externo, utilizar el volumen local.

![(Imagen)](https://github.com/kodo13/proyectoCharlie/blob/main/pictures/Captura%20desde%202022-11-03%2017-57-45.png?raw=true)
> Cambio del volumen a usar.

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

---
---
# Configuración DNS

Queremos configurar un servidor DNS que nos resuelva dos dominios, los cuales apuntan a la IP fija de nuestro apache. 

Estos dominios serán: 

- oscuras.fabulas.com
- maravillosas.fabulas.com

Como en la práctica anterior hemos configurado un servidor DNS, vamos a aprovecharlo y copiar la configuración para posteriormente adaptarla a nuestros servicios.



[Práctica 1- DNS](https://github.com/kodo13/Practica1-DNS) 
> Acceso al repositorio de la configuración del DNS.



Una vez bajada la configuración del DNS a nuestra carpeta de confDNS, ahora procedemos a adaptarlo a nuestro proyecto.

### *Configuración ficheros Zonas*

Primero editamos el nombre del fichero de nuestra zona a *db.fabulas.com*.

Le damos un nombre a nuestro registro SOA, ns.fabulas.com, siendo este  nuestro dominio.

Además, ya añadimos el registro de tipo A (Adress). Este es un registro de dirección, el cual nos devuelve una dirección IP.

Como queremos que sea el apache el que almacene nuestros dominios, entonces asignamos la IP de nuestro servidor apache.
#### *Configuración dominios*

Un dominio es el de *oscuras.fabulas.com*, que es el que va asignado directamente a la IP del apache. 

EL otro dominio es el de *maravillosas.fabulas.com*, que está configurada con un tipo de registro CNAME, que es el alias que apunta a oscuras. De esta forma, podremos acceder a dos dominios distintos usando la misma IP.

falta imagen

>El registro DNS CNAME funciona como un alias para los nombres de dominio que comparten una misma dirección IP.

### *Configuración fichero named.conf.local*

Primero accedemos al fichero *named.conf.local* y editamos nuestra zona, dándole el nombre de nuestro dominio *fabulas.com*. 

Además, tenemos que asegurarnos que la referencia a file apunte a nuestro fichero de la zona.


## Configuración *docker-compose*
- #### Añadimos el servicio de DNS

Simplemente copiamos y pegamos el servicio de bind9  de la práctica del DNS. 

Es muy importante mapear los volumes con el directorio de nuestro proyecto, que contiene la configuración que hicimos más anteriormente.  


```
  bind9: 
    container_name: bind9
    image: internetsystemsconsortium/bind9:9.16
    volumes:
      - /home/dony/SRI/proyectoCharlie/confDNS/conf:/etc/bind
      - /home/dony/SRI/proyectoCharlie/confDNS/zonas:/var/lib/bind
    networks:
      bind9_subnet:
        ipv4_address: 10.0.1.254 #IP fija del DNS.

```
Una vez listo, añadimos la IP fija también al servidor apache. Tenemos que asegurarnos de usar la misma red del DNS.

Imagen ip fija Apache

- #### Añadimos el servicio del cliente firefox.

[Cliente firefox](https://hub.docker.com/r/linuxserver/firefox) 
> Documentación seguida para la creación del cliente firefox.

```
  bind9: 
    container_name: bind9
    image: internetsystemsconsortium/bind9:9.16
    volumes:
      - /home/dony/SRI/proyectoCharlie/confDNS/conf:/etc/bind
      - /home/dony/SRI/proyectoCharlie/confDNS/zonas:/var/lib/bind
    networks:
      bind9_subnet:
        ipv4_address: 10.0.1.254 #IP fija del DNS.
  firefox:
    image: lscr.io/linuxserver/firefox:latest
    container_name: firefox
    security_opt:
      - seccomp:unconfined #optional
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Europe/London
    volumes:
      - /home/dony/SRI/proyectoCharlie/firefox:/config
    ports:
      - 3000:3000
    networks:
      bind9_subnet:
        ipv4_address: 10.0.1.249
    dns:                
      - 10.0.1.254     
      #En el cliente de firefox, le tenemos que poner cual es
    #el DNS al que tiene que preguntar para la resolución de nombres.   
    shm_size: "1gb"
    restart: unless-stopped

```
#### Pasos a seguir para la configuración del cliente firefox

- Creación de directorio del cliente.
- Mapeo del volumen al directorio de firefox.

  `/home/dony/SRI/proyectoCharlie/firefox:/config`

- Mapeo del puerto.

  `3000:3000`

- Añadir IP fija al cliente (opcional).

  ```
  networks:
        bind9_subnet:
          ipv4_address: 10.0.1.249

  ```

- Añadir el dns. 

  Muy importante para que cuando hagamos una consulta escribiendo el dominio, este sea capaz de saber a quien preguntar y que se resuleva con éxito.


  ```
  dns:                
      - 10.0.1.254     
      #En el cliente de firefox, le tenemos que poner cual es
    #el DNS al que tiene que preguntar para la resolución de nombres.   
  ```

----
----
## Configuración de virtual-host

>Tendremos dos Virtualhost separados para cada dominio en el mismo puerto (80)

En el directorio de *confApache*, tenemos toda la configuración del Apache. Desplegando este, podemos ver todos los directorios. 

A nosotros nos interesan 4 específicos, siendo estos: 
- sites-available
    - Aquí tenemos todos los sitios disponibles.
- sites-enabled
    - En este directrio, tenemos todos los sitios que tengamos habilitados, los que no estén en este directorio no estarán activos.
- ports.conf
    - Configuración de los puertos de escucha.

### Creación de los index de cada sitio

Teníamos el directorio html creado de antes, con los respectivos directorios de site1 y site2. En estos tenemos que crear los index.html, los cuales se mostrarán al acceder desde oscuras.fabulas.com y maravillosas.fabulas.com


----
----
## Comprobación del funcionamiento

Situados en la ruta donde tenemos nuestro proyecto con todos los directorios y el docker-compose, ejecutamos el comando `docker-compose up` para arrancar los servicios.



