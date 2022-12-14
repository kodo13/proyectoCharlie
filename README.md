
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
```
 ports:
      - '80:80'
```

[DocumentRoot](https://httpd.apache.org/docs/2.4/mod/core.html#documentroot)
> Documentación para saber el correcto mapeo.

Seguido, mapeamos la configuración de Apache en un nuevo volumen.
```
volumes:
      - ./html:/var/www/html ##Mapeo de nuestra carpeta local con el DocumentRoot
      - confApache:/etc/apache2 

```





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
Por defecto, el servidor Apache muestra el contenido de /var/www/html/. Entoces, mapeamos el volumen de nuestra carpeta html a este directorio. Para que veamos si funciona, creamos un index.html con un "Hola mundo", que es lo que se se abre por defecto al acceder.

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

Queremos configurar un servidor DNS que nos resuelva dos subdominios, los cuales apuntan a la IP fija de nuestro apache y que ertenece al dominio de fabulas.com.

Estos subdominios serán: 

- oscuras.fabulas.com
- maravillosas.fabulas.com

Como en la práctica anterior hemos configurado un servidor DNS, vamos a aprovecharlo y copiar la configuración para posteriormente adaptarla a nuestros servicios.



[Práctica 1- DNS](https://github.com/kodo13/Practica1-DNS) 
> Acceso al repositorio de la configuración del DNS.



Una vez bajada la configuración del DNS a nuestra carpeta de confDNS, ahora procedemos a adaptarlo a nuestro proyecto.

### *Configuración ficheros Zonas*



```
$TTL 38400	; 10 hours 40 minutes
@		IN SOA	ns.fabulas.com. some.email.address. (
				10000002   ; serial
				10800      ; refresh (3 hours)
				3600       ; retry (1 hour)
				604800     ; expire (1 week)
				38400      ; minimum (10 hours 40 minutes)
				)
@		IN NS	ns.fabulas.com.
ns		IN A 	10.0.1.254
oscuras	IN A	10.0.1.250
maravillosas	IN CNAME    oscuras
alias	IN TXT    mensaje

```

Primero editamos el nombre del fichero de nuestra zona a *db.fabulas.com*.

Le damos un nombre a nuestro registro SOA, ns.fabulas.com, siendo este  nuestro dominio.

`@		IN SOA	ns.fabulas.com. some.email.address.`

Además, ya añadimos el registro de tipo A (Address). Este es un registro de dirección, el cual nos devuelve una dirección IP.

Como queremos que sea el apache el que almacene nuestros dominios, entonces asignamos la IP de nuestro servidor apache.

`ns		IN A 	10.0.1.254`
#### *Configuración dominios*

Un dominio es el de *oscuras.fabulas.com*, que es el que va asignado directamente a la IP del apache. 

EL otro dominio es el de *maravillosas.fabulas.com*, que está configurada con un tipo de registro CNAME, que es el alias que apunta a oscuras. De esta forma, podremos acceder a dos dominios distintos usando la misma IP.

```
oscuras	IN A	10.0.1.250
maravillosas	IN CNAME    oscuras

```


![(Imagen)](https://github.com/kodo13/proyectoCharlie/blob/main/pictures/conf_zonas.png?raw=true)

>El registro DNS CNAME funciona como un alias para los nombres de dominio que comparten una misma dirección IP.

### *Configuración fichero named.conf.local*

Primero accedemos al fichero *named.conf.local* y editamos nuestra zona, dándole el nombre de nuestro dominio *fabulas.com*. 

Además, tenemos que asegurarnos que la referencia a file apunte a nuestro fichero de la zona.

![(Imagen)](https://github.com/kodo13/proyectoCharlie/blob/main/pictures/conf_zone.png?raw=true)

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

```
networks:
      bind9_subnet:
        ipv4_address: 10.0.1.250 #Establecemos una IP fija a nuestro servidor apache.
```

![(Imagen)](https://github.com/kodo13/proyectoCharlie/blob/main/pictures/IP_fija_apache.png?raw=true)

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

- Añadir el DNS. 

  Muy importante para que cuando hagamos una consulta escribiendo el dominio, este sea capaz de saber a quien preguntar y que se resuelva con éxito.


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
    ![(Imagen)](https://github.com/kodo13/proyectoCharlie/blob/main/pictures/sitio1.png?raw=true)
    >Sitio 1. Vemos que permite conexión desde cualquier IP al puerto 80. Aquí también tenemos que descomentar la línea de ServerName y escribir el nombre del subdominio al que queremos acceder y así también poder acceder a uno u otro que están en la misma IP.

    ![(Imagen)](https://github.com/kodo13/proyectoCharlie/blob/main/pictures/site2.png?raw=true)
    >Sitio 2
- ports.conf
    - Configuración de los puertos de escucha.
    ![(Imagen)](https://github.com/kodo13/proyectoCharlie/blob/main/pictures/ports.png?raw=true)

### Creación de los index de cada sitio

Teníamos el directorio html creado de antes, con los respectivos directorios de site1 y site2. En estos tenemos que crear los index.html, los cuales se mostrarán al acceder desde oscuras.fabulas.com y maravillosas.fabulas.com
![(Imagen)](https://github.com/kodo13/proyectoCharlie/blob/main/pictures/creacionSitios.png?raw=true)

----
----
## Comprobación del funcionamiento

Situados en la ruta donde tenemos nuestro proyecto con todos los directorios y el docker-compose, ejecutamos el comando `docker-compose up` para arrancar los servicios.

Una vez arrancados, podemos probar si el cliente tiene conexión con el DNS abriendo una terminal y haciendo ping al DNS y al apache. 

Otra forma mucho más visual es abriendo nuestro navegador y conectarnos al cliente, poniendo la IP del cliente y el puerto al que está mapeado.


![(Imagen)](https://github.com/kodo13/proyectoCharlie/blob/main/pictures/conexionCliente.png?raw=true)

---
Una vez conectados, intentamos acceder al subdominio de *oscuras.fabulas.com* y ver si nos resuelve.

![(Imagen)](https://github.com/kodo13/proyectoCharlie/blob/main/pictures/oscuras.png?raw=true)

---
![(Imagen)](https://github.com/kodo13/proyectoCharlie/blob/main/pictures/maravillosas.png?raw=true)

>Prueba de conexión a maravillosas.fabulas.com

----
----
# Configuración SSL

El servicio SSL hace la escucha por el puerto 443, por eso, tenemos que modificar el docker compose añadiendo este puerto.

![(Imagen)]()imagen añadir puerto

Ahora levantamos los servicios ejecutando `docker-compose up` desde el directorio donde tengamos el fichero docker-compose.yml.

Una vez arrancado, abrimos la shell del Apache, hacemos click derecho sobre dicho contenedor y le damos a *Attach Shell*. En esta shell, ejecutamos el comando `a2enmod ssl` para habilitar el módulo Apache con el nombre Mod_ssl. 

Nos puede dar un error si el módulo ya está habilitado, si lo está, lo borramos del directorio de mods-enabled y después ejecutamos el comando otra vez. Una vez habilitado, tenemos que reiniciar el servicio para que se hagan efectivos los cambios.

## Generar certificados SSL

Primero creamos una carpeta dentro de confApache llamada certs, donde guardaremos los certificados. 

Nos movemos a esta carpeta `cd /ect/apache2/certs`, para posteriormente generar los certificados.

Para generar los certificados, ejecutamos le siguiente comando: 

```
openssl req -new -newkey rsa:4096 -x509 -sha256 -days 365 -nodes -out apache-certificate.crt -keyout apache.key

```

Se nos pedirá una serie de información, la cubrimos y listo, tendremos los certificados creados correctamente.

## Crear y habilitar sitio SSL 

Ahora vamos a los sites-available y vemos que tenemos un sitio que se llama default-ssl.conf. Abrimos este fichero para cambiar la configuración a nuestro entorno.

- Antes de nada, creamos dentro del directorio *html*, una carpeta con el nombre de *ssl*, donde creamos también un *index.html* que nos indique que funcione el servicio ssl.

- Creado el directorio, en el fichero de *default-ssl.conf*, en DocumentRoot, le ponemos la ruta al directorio ssl creado anteriormente.

![(Imagen)](https://github.com/kodo13/proyectoCharlie/blob/main/pictures/sitessl.png?raw=true)

- En el mismo fichero, tenemos que asegurarnos de que tenemos bien mapeados los ficheros de los certificados. En mi caso, son las líneas 43 y 44. 

![(Imagen)](https://github.com/kodo13/proyectoCharlie/blob/main/pictures/mapeocerts.png?raw=true)

Observamos que tenemos que poner la ruta y el nombre exacto de nuestros ficheros con las keys.

### Habilitar sitio SSL

Desde la shell del apache, ejecutamos el comando `a2ensite dafault-ssl.conf` para habilitarlo. 

Una vez listo, vamos al contenedor del apache y, haciendo ciclk derecho sobre el, le damos a restart para que se establezcan los cambios.

## Comprobación del funcionamiento del sitio SSL

Desde el navegador del host, accedemos a https://localhost y nos debería aparecer el contenido del index.html del ssl.

![(Imagen)](https://github.com/kodo13/proyectoCharlie/blob/main/pictures/comprobacion.png?raw=true)

Otra manera de hacer la comprobación es mediante un cliente, nos conectamos al cliente firefox que tenemos creado. Lo hacemos mediante su IP y su puerto, *10.0.1.249:3000*.

Una vez dentro, accedemos a nuestro dominio https://oscuras.fabulas.com. 

![(Imagen)](https://github.com/kodo13/proyectoCharlie/blob/main/pictures/aviso.png?raw=true)
>Nos salta aviso de que puede que no sea un sitio seguro. Le damos a Avance aceptamos.

![(Imagen)](https://github.com/kodo13/proyectoCharlie/blob/main/pictures/accesoSeguroyNo.png?raw=true)
> Observamos a la izquierda el acceso seguro mediante el https y a la izquierda, el acceso no seguro, al cual accedemos directamente por el dominio.


Observamos que podemos acceder a la misma página de una forma segura con el https y otra no seguras, simplemente poniendo el dominio.

# Autentificación, Autorización y Control de Acceso

Primero creamos una nueva carpeta llamada passwords, dentro del directorio de confApache.

Tenemos que crear un archivo de contraseñas, para ello usaremos la utilidad htpasswd que ya viene con Apache.

Abrimos la shell de nuestro Apache y nos movemos a la carpeta de passwoords. Una vez ahí, ejecutamos el comando htpasswd -c pass ionut (siendo pass el nombre de un fichero que se creará e ionut el nombre del usuario).

Se nos pedirá una contraseña e introducirla una segunda vez para comprobar que sea la misma.

Si htpasswd no está en nuestra ruta, tendremos que escribir la ruta completa al archivo para ejecutarlo.

El siguiente paso es configurar el servidor para que solicite una contraseña y decirle al servidor a qué usuarios se les permite el acceso. Esto lo haremos editando el fichero del sitio ssl, *default-ssl.con*.

Tenemos que añadir un nuevo directory con una configuración básica.
![Imagen](https://github.com/kodo13/proyectoCharlie/blob/main/pictures/confAutorizaci%C3%B3n.png?raw=true)

```
<Directory /var/www/html/ssl >
            AuthType Basic
            AuthName "Restricted Files"
            AuthUserFile /etc/apache2/passwords/pass
            Require user ionut
        </Directory>

```
> Configuración
- Al lado de *directory* ponemos la ruta del directorio donde tenemos el sitio ssl.
- En *AuthUserFile*, indicamos ruta al fichero de la contraseña.
- Añadimos nombre del usuario con acceso en la útlima línea, *Require user*.

## Comprobación del funcionamiento

Podemos hacer la comprobación desde el navegador entrando por https://localhost o a través del cliente de firefox.

Lo vamos a hacer a través del cliente de firefox, nos conectamos al cliente y, en el navegador, escribimos https://oscuras.fabulas.com.

***Importante*** Para acceder a través del dominio, tenemos que tener el directory también configurado en el virtualhost donde tengamos configurado el ServerName.

![Imagen](https://github.com/kodo13/proyectoCharlie/blob/main/pictures/comprobaar%20autentificacion.png?raw=true)
> Ventana emergente en la que se nos pide que iniciemos sesión. Introducimos los datos del usuario que añadimos en la configuración y la contraseña establecida.

![Imagen](https://github.com/kodo13/proyectoCharlie/blob/main/pictures/yadentro.png?raw=true)
> Conexión establecida, cemos que al lado del cando nos aparece una llave, lo que nos indica que hemos accedido a través de la autenficación.

# MySQL y PHPmyAdmin

Vamos a añadir dos nuevos servicios, el de MySQL y PHPmyAdmin.

Añadimos la siguiente configuración en el codker-compose.yml.

> *Configuración phpmyadmin*

```
phpmyadmin:
        image: phpmyadmin/phpmyadmin
        depends_on: #indica que hasta que no esté levantado el otro servicio, que no se arranque este.
            - db
        links: 
            - db:db
        networks:
          bind9_subnet:
            ipv4_address: 10.0.1.248
        ports:
            - 8080:80
        environment:
            MYSQL_USER: dera
            MYSQL_PASSWORD: castelao
            MYSQL_ROOT_PASSWORD: castelao
```

> *Configuración mysql*

```
db:
        image: mysql
        ports: 
            - "3306:3306"
        environment:
            MYSQL_DATABASE: asir2
            MYSQL_USER: dera
            MYSQL_PASSWORD: castelao
            MYSQL_ROOT_PASSWORD: castelao
        volumes:
            - ./mysql:/docker-entrypoint-initdb.d
            - ./mysql:/var/lib/mysql
        networks:
            bind9_subnet:
              ipv4_address: 10.0.1.247
```

## Comprobación del funcionamiento

### Conexión al phpmyadmin

Para conectarnos a PHPmyAdmin, ponemos la IP que le pusimos en el navegador y ya se nos abrirá. 

![Imagen](https://github.com/kodo13/proyectoCharlie/blob/main/pictures/php.png?raw=true)
> Página de inicio de phpmyadmin. Introducimos los datos del usuario que creamos y escribimos la contraseña establecida para realizar la conexión.

Ya conectados, hemos creado una nueva tabla con 3 columnas en las que se hicieron algunos inserts.

![Imagen](https://github.com/kodo13/proyectoCharlie/blob/main/pictures/insercondatos.png?raw=true)
> Vista de los datos de la base de datos asir2.


