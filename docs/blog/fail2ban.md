# Instalación y uso de herramienta de seguridad Fail2Ban en Debian Stretch 9.5  

Vamos a ver esta vez una buena herramienta que funcionará como Sistema de Detección de Intrusos (IDS o HIDS), Fail2ban nos permite ver los accesos o intentos de accesos en el sistema o en servicios del sistema y además podremos aplicar medidas. Funciona leyendo ficheros de logs y aplicando reglas de iptables.


***
## Características Fail2Ban

Está desarrollado en Python3 y tiene las siguientes funcionalidades:

* Cliente/Servidor.
* Multiprocesamiento.
* Autodetección del formato de la fecha.
* Soporte para bastantes servicios como ssh o apache.
* Soporte para realizar acciones como iptables o envío de correos.
* Compatible con SystemD y SystemV.
* Usa una base de datos SQLite3 para guardar los baneos.


***
## Definiciones

Fail2Ban usa 

* `filter`  
Son las expresiones regulares utilizadas para el "parseo" de los logs.

* `action`  
Son las acciones a realizar según los acontecimientos encontrados en los logs.

* `jail`
Son un conjunto de `filter` y `action` utilizados independientemente por cada servicio denominado. Puede ser por ejemplo "ssh" o "apache2" o incluso variaciones de estas ya incluidas.

!!! note ""
	Podemos crear `filter` , `action` y `jail` personalizados que veamos oportunos para nuestro sistema customizado.


***
## Configuración inicial de la máquina

### Máquina virtual con Vagrant y VirtualBox:

Fichero Vagrantfile:
``` ruby
# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.define "nodo1" do |nodo1|

    config.vm.provider "virtualbox" do |vb|
      vb.name = "jpfail"
    end

    nodo1.vm.box = "debian/stretch64"
    nodo1.vm.hostname = "jpfail"
    nodo1.vm.network "public_network",
      bridge: "wlan0",
      use_dhcp_assigned_default_route: true

  end

end
```

### Accedemos mediante SSH:
``` bash
vagrant ssh
```


***
## Instalación

### Actualización del sistema:
``` bash
suso su -
apt update && apt -y upgrade
```

### Requerimientos:

Actualmente la última versión de Fail2ban es la `0.9.6`.
Esta versión requiere uno de los siguientes paquetes:

 Python 2.6 o superior.  
 Python 3.2 o superior.  
 PyPy.  

### Instalamos Fail2Ban:
``` bash
apt -y install fail2ban
```



***
## Ficheros de configuración

Los ficheros de configuración de Fail2Ban se encuentran en `/etc/fail2ban`.

También existe uno en `/etc/default/fail2ban` que configura el usuario que usará Fail2Ban que por defecto es "root" además se podrá configurar con opciones del arranque de esta herramienta.

### Generales

* fail2ban.conf

Es la configuración principal de Fail2Ban y en el configuraremos lo siguiente:
``` bash
loglevel = INFO

logtarget = /var/log/fail2ban.log

syslogsocket = auto

socket = /var/run/fail2ban/fail2ban.sock

pidfile = /var/run/fail2ban/fail2ban.pid

dbfile = /var/lib/fail2ban/fail2ban.sqlite3

dbpurgeage = 86400
```

También podremos modificar estas configuraciones con el comando `fail2ban-client` que veremos más adelante.

* paths-\*.conf

Es la declaración de los directorios de los logs usados con esta herramienta.

### FILTERS



### ACTIONS



### JAILS

* jail.conf

Es la configuración principal de los `JAILS`  


***
## Scripts o comandos de Fail2Ban

### fail2ban-server  

Este arranca en segundo plano automáticamente al instalarse Fail2Ban y es el proceso principal.  

Opciones disponibles:
``` bash
-b                   start in background
-f                   start in foreground
-s <FILE>            socket path
-p <FILE>            pidfile path
-x                   force execution of the server
```

### fail2ban-client  

Es el "frontend" y el que se comunica con el servidor enviándole órdenes y configuraciones.  

Opciones disponibles:
``` bash
-c <DIR>                configuration directory
-d                      dump configuration. For debugging
-i                      interactive mode
-v                      increase verbosity
-q                      decrease verbosity
-x                      force execution of the server
```

Comandos básicos:
``` bash
reload                  reloads the configuration
reload <JAIL>           reloads the jail <JAIL>
stop                    stops all jails and terminate the server
status                  gets the current status of the server
ping                    tests if the server is alive
```

Comandos de log:
``` bash
set loglevel <LEVEL>                     sets logging level to <LEVEL>.
                                         Levels: CRITICAL, ERROR, WARNING,
                                         NOTICE, INFO, DEBUG

get loglevel                             gets the logging level

set logtarget <TARGET>                   sets logging target to <TARGET>.
                                         Can be STDOUT, STDERR, SYSLOG or a
                                         file

get logtarget                            gets logging target

set syslogsocket auto|<SOCKET>           sets the syslog socket path to
                                         auto or <SOCKET>. Only used if
                                         logtarget is SYSLOG

get syslogsocket                         gets syslog socket path

flushlogs                                flushes the logtarget if a file
                                         and reopens it. For log rotation.
```

Comandos de la base de datos:
``` bash
set dbfile <FILE>                        set the location of fail2ban
                                         persistent datastore. Set to
                                         "None" to disable

get dbfile                               get the location of fail2ban
                                         persistent datastore

set dbpurgeage <SECONDS>                 sets the max age in <SECONDS> that
                                         history of bans will be kept

get dbpurgeage                           gets the max age in seconds that
                                         history of bans will be kept
```

Además tiene una bastante cantidad de comandos que actúan sobre la configuración de los `JAILS` en el que veremos algún ejemplo más adelante.

### fail2ban-regex

Se usa para realizar tests con expresiones regulares específicas o personalizadas.

### fail2ban-testcases

Se usa para realizar un test general.









[Fail2Ban](http://www.fail2ban.org/wiki/index.php/Main_Page)

<img src="../../img/oracleinstall/captura1.png" alt="captura1" width="500" height="400" />


