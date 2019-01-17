# Acceso remoto a servidor Postgresql

En esta ocasión veremos de forma sencilla conectarnos a un servidor remoto de postgresql.

## Instalación cliente Postgresql

``` bash
sudo apt install postgresql-client-9.6
```

## Conexion remota

``` bash
psql -h 172.22.200.63 -U prueba -d prueba2
```

Donde:

 * `-h` es la ip del servidor.
 * `-U` es el usuario con el que accedemos.
 * `-d` es el nombre de la base de datos a la que nos conectamos.

## Pruebas de conexión

* Aquí vemos que la conexión está establecida:

![](../../img/postgresclient/captura1.png)

* Ejecutamos varios consultas como ver las tablas o ver los campos de una tabla:

![](../../img/postgresclient/captura2.png)

