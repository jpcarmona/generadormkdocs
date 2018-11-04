# Instalación y uso de herramienta de seguridad Fail2Ban en Debian Stretch 9.5  

Vamos a ver esta vez una buena herramienta que funcionará como Sistema de Detección de Intrusos (IDS o HIDS).  
Fail2ban nos permite ver los accesos o intentos de accesos en el sistema o en servicios del sistema y además podremos aplicar medidas. Funciona leyendo ficheros de logs y aplicando reglas de iptables.


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

### Arrancamos máquina:
``` bash
vagrant up
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

#### /etc/fail2ban/fail2ban.conf

Es la configuración principal de Fail2Ban y en el se encuentra lo siguiente:
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

#### /etc/fail2ban/paths-\*.conf

Es la declaración de los directorios de los logs principales usados con esta herramienta.

### FILTERS

#### /etc/fail2ban/filter.d/\*.conf

Aquí se encuentran las configuraciones de las expresiones regulares utilizadas para el parseo de logs en cada servicio o `jail`.

Un ejemplo sería por ejemplo el el fichero `apache-common.conf`:

``` bash
[DEFAULT]

_apache_error_client = \[\] \[(:?error|\S+:\S+)\]( \[pid \d+(:\S+ \d+)?\])? \[client <HOST>(:\d{1,5})?\]
```

En el se ve la expresión regular que busca si ha habido algún error con un cliente.

### ACTIONS

#### /etc/fail2ban/action.d/\*.conf

Aquí se encuentran las configuraciones de las acciones principales a realizar en caso de estar configurado en un servicio o `jail`.

Un ejemplo sería por ejemplo el el fichero `iptables.conf`:

``` bash
[INCLUDES]

before = iptables-common.conf

[Definition]

actionstart = <iptables> -N f2b-<name>
              <iptables> -A f2b-<name> -j <returntype>
              <iptables> -I <chain> -p <protocol> --dport <port> -j f2b-<name>

actionstop = <iptables> -D <chain> -p <protocol> --dport <port> -j f2b-<name>
             <iptables> -F f2b-<name>
             <iptables> -X f2b-<name>

actioncheck = <iptables> -n -L <chain> | grep -q 'f2b-<name>[ \t]'

actionban = <iptables> -I f2b-<name> 1 -s <ip> -j <blocktype>

actionunban = <iptables> -D f2b-<name> -s <ip> -j <blocktype>

[Init]

```

En este fichero se encuentran las acciones definidas a relizar si se usa esta `action` como comprobar las reglas "iptables", añadir una regla, eliminarla, etc...

### JAILS

#### /etc/fail2ban/jail.conf

Es la configuración principal de los `JAILS`. Aquí se encuentran las configuraciones de todos los `jails` que se pueden usar pero que no estan activados por defecto y no se recomienda modificar.

Un ejemplo son las configuraciones por defecto:

``` bash
[DEFAULT]

ignoreip = 127.0.0.1/8

bantime  = 600

findtime  = 600

maxretry = 5
```

Más abajo se definen las configuraciones de algunas `actions` y todos los `jails` que se pueden usar.

#### /etc/fail2ban/jail.d/\*.conf

Existe un solo fichero que es `/etc/fail2ban/jail.d/defaults-debian.conf`. En el se configurará la activación de los `jails`.

``` bash
[sshd]
enabled = true
```

Por defecto solo está activado el `jail` de ssh.

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


***
## Ejemplo de funcionamiento

Vamos a comprobar si funciona el `jail` por defecto que es "sshd".

Miramos los jails activados con:

``` bash
fail2ban-client status
```

Nos responde:

``` bash
Status
|- Number of jail:  1
`- Jail list: sshd
```

Podemos ver los estados de ese `jail` en concreto:

``` bash
fail2ban-client status sshd
```

Nos responde:

``` bash
Status for the jail: sshd
|- Filter
|  |- Currently failed: 0
|  |- Total failed: 0
|  `- File list:  /var/log/auth.log
`- Actions
   |- Currently banned: 0
   |- Total banned: 0
   `- Banned IP list: 
```

Ahora procedemos a forzar intentos fallidos de autenticación mediante ssh hacia la máquina desde mi máquina anfitrión:

``` bash
ssh vagrant@192.168.1.27
```


``` bash
pedro@jpdeb1:~$ ssh vagrant@192.168.1.27
vagrant@192.168.1.27's password: 
Permission denied, please try again.
vagrant@192.168.1.27's password: 
Permission denied, please try again.
vagrant@192.168.1.27's password: 
Permission denied (publickey,password).
pedro@jpdeb1:~$ ssh vagrant@192.168.1.27
vagrant@192.168.1.27's password: 
Permission denied, please try again.
vagrant@192.168.1.27's password: 

```

En el sexto intento se queda la petición en el aire sin devolvernos error ni nada ya que el máximo de intentos configurados por defecto es de "5" en el fichero `/etc/fail2ban/jail.conf` en la opción `maxretry =`.

Y este es el estado del `jail`:

``` bash
fail2ban-client status sshd
```

``` bash
Status for the jail: sshd
|- Filter
|  |- Currently failed: 1
|  |- Total failed: 6
|  `- File list:  /var/log/auth.log
`- Actions
   |- Currently banned: 1
   |- Total banned: 1
   `- Banned IP list: 192.168.1.4
```

Regla de "iptables" creada:

``` bash
root@jpfail:~# iptables -L
Chain INPUT (policy ACCEPT)
target     prot opt source               destination         
f2b-sshd   tcp  --  anywhere             anywhere             multiport dports ssh

Chain FORWARD (policy ACCEPT)
target     prot opt source               destination         

Chain OUTPUT (policy ACCEPT)
target     prot opt source               destination         

Chain f2b-sshd (1 references)
target     prot opt source               destination         
REJECT     all  --  192.168.1.4          anywhere             reject-with icmp-port-unreachable
RETURN     all  --  anywhere             anywhere          
```

Por defecto esa ip estará "baneada" durante "600" segundos configurados en el fichero `/etc/fail2ban/jail.conf` en la opción `bantime =`.

### Viendo la configuración del jail "sshd"

#### Fichero `/etc/fail2ban/jail.conf`:

``` bash
[sshd]

port    = ssh
logpath = %(sshd_log)s
backend = %(sshd_backend)s
```

Aquí se define lo siguiente:

* Nombre del JAIL: sshd
* Puerto = ssh
* Path del log: %(sshd_log)s  
Que esto remite al fichero `/etc/fail2ban/paths-common.conf` donde:
``` bash
sshd_log = %(syslog_authpriv)s
```
Y donde finalmente el fichero del log del JAIL "sshd" es:
``` bash
syslog_authpriv = /var/log/auth.log
```
Definido en el fichero `/etc/fail2ban/paths-debian.conf`

#### Fichero `/etc/fail2ban/filter.d/sshd.conf`:

``` bash
[Definition]

_daemon = sshd

failregex = ^%(__prefix_line)s(?:error: PAM: )?[aA]uthentication (?:failure|error|failed) for .* from <HOST>( via \S+)?\s*$
            ^%(__prefix_line)s(?:error: PAM: )?User not known to the underlying authentication module for .* from <HOST>\s*$
            ^%(__prefix_line)sFailed \S+ for (?P<cond_inv>invalid user )?(?P<user>(?P<cond_user>\S+)|(?(cond_inv)(?:(?! from ).)*?|[^:]+)) from <HOST>(?: port \d+)?(?: ssh\d*)?(?(cond_user):|(?:(?:(?! from ).)*)$)
            ^%(__prefix_line)sROOT LOGIN REFUSED.* FROM <HOST>\s*$
            ^%(__prefix_line)s[iI](?:llegal|nvalid) user .*? from <HOST>(?: port \d+)?\s*$
            ^%(__prefix_line)sUser .+ from <HOST> not allowed because not listed in AllowUsers\s*$
            ^%(__prefix_line)sUser .+ from <HOST> not allowed because listed in DenyUsers\s*$
            ^%(__prefix_line)sUser .+ from <HOST> not allowed because not in any group\s*$
            ^%(__prefix_line)srefused connect from \S+ \(<HOST>\)\s*$
            ^%(__prefix_line)s(?:error: )?Received disconnect from <HOST>: 3: .*: Auth fail(?: \[preauth\])?$
            ^%(__prefix_line)sUser .+ from <HOST> not allowed because a group is listed in DenyGroups\s*$
            ^%(__prefix_line)sUser .+ from <HOST> not allowed because none of user's groups are listed in AllowGroups\s*$
            ^(?P<__prefix>%(__prefix_line)s)User .+ not allowed because account is locked<SKIPLINES>(?P=__prefix)(?:error: )?Received disconnect from <HOST>: 11: .+ \[preauth\]$
            ^(?P<__prefix>%(__prefix_line)s)Disconnecting: Too many authentication failures for .+? \[preauth\]<SKIPLINES>(?P=__prefix)(?:error: )?Connection closed by <HOST> \[preauth\]$
            ^(?P<__prefix>%(__prefix_line)s)Connection from <HOST> port \d+(?: on \S+ port \d+)?<SKIPLINES>(?P=__prefix)Disconnecting: Too many authentication failures for .+? \[preauth\]$
            ^%(__prefix_line)s(error: )?maximum authentication attempts exceeded for .* from <HOST>(?: port \d*)?(?: ssh\d*)? \[preauth\]$
            ^%(__prefix_line)spam_unix\(sshd:auth\):\s+authentication failure;\s*logname=\S*\s*uid=\d*\s*euid=\d*\s*tty=\S*\s*ruser=\S*\s*rhost=<HOST>\s.*$

ignoreregex = 

[Init]

# "maxlines" is number of log lines to buffer for multi-line regex searches
maxlines = 10

journalmatch = _SYSTEMD_UNIT=sshd.service + _COMM=sshd

```

Aquí vemos una gran cantidad de expresiones regulares usadas, además en la opción `_daemon` se especifica el nombre del JAIL.

#### Actions en SSHD

Las acciones a relizar son las definidas por defecto en el fichero `/etc/fail2ban/jail.conf`:

``` bash
banaction = iptables-multiport

action_ = %(banaction)s[name=%(__name__)s, bantime="%(bantime)s", port="%(port)s", protocol="%(protocol)s", chain="%(chain)s"]

```

Que será la `action` definida en el fichero `/etc/fail2ban/action.d/iptables-multiport.conf`.

***
## Configuración para mysql y Apache2



[Fail2Ban](http://www.fail2ban.org/wiki/index.php/Main_Page)

[10 IDS](https://www.comparitech.com/net-admin/network-intrusion-detection-tools/)



