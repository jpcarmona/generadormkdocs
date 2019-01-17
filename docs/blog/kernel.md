# Kernel Linux

En este post veremos como configurar el kernel linux y adaptarlo a las necesidades mínimas de nuestra máquina.

## Instalación

Antes de instalar algo en Entornos Debian:  
``` bash
sudo apt update
sudo apt upgrade
```

Instalamos el paquete del kernel:
``` bash
sudo apt-get install linux-source-4.9
```
Nos creará un fichero en /usr/src/linux-source-4.9.tar.bz2

Instalamos las bibliotecas de desarrollo para configurar el kernel eligiendo la que mas nos guste:

* menuconfig
``` bash
sudo apt-get install libncurses5-dev
```
* gconfig:
``` bash
sudo apt-get install libgtk2.0-dev libglib2.0-dev libglade2-dev
```
* xconfig
``` bash
sudo apt-get install libqt4-dev
```

Utilizamos un directorio donde trabajar:
``` bash
mkdir ~/kernel
cd ~/kernel
cp /usr/src/linux-source-4.9.tar.xz ./
tar -xJf linux-source-4.9.tar.xz
```

Utilizamos el fichero de configuración de módulos del kernel actual:
``` bash
cp /boot/config-`uname -r` ~/kernel/linux-source-4.9/.config
```

Etiquetamos la versión del kernel que vamos a crear:
``` bash
nano ~/kernel/linux-source-4.9/Makefile
```

Editamos la línea `EXTRAVERSION`:

``` bash hl_lines="4"
VERSION = 4
PATCHLEVEL = 9
SUBLEVEL = 110
EXTRAVERSION =-1
NAME = Roaring Lionus
```

Creamos una nueva configuración del kernel adaptada a nuestra máquina con:
``` bash
cd ~/kernel/linux-source-4.9/
make localmodconfig
```
Con esto nos habrá configurado el fichero `~/kernel/linux-source-4.9/.config` automáticamente.

Ahora podemos usar una de las herramientas de configuración del kernel estando en el directorio `~/kernel/linux-source-4.9/`:

``` bash
make menuconfig
```
``` bash
make gconfig
```
``` bash
make xconfig
```

Yo usaré `xconfig`:

<img src="/img/xconfig.png" alt="xconfig" width="400" height="400" />

Marcamos las casillas de los módulos que necesitamos y guardamos.Ahora se ha modificado otra vez el fichero `~/kernel/linux-source-4.9/.config`.

Con esto ya compilamos:
``` bash
make deb-pkg
```
Podemos usar la herramienta time para ver cuanto tarda:
``` bash
time make deb-pkg
```
Por defecto el compilador solo usa un core a la vez, si queremos usar mas de uno utilizamos el siguiente parámetro:
``` bash
time make -j 4 deb-pkg
```

Nos creará varios ficheros en el directorio padre:
``` bash hl_lines="4 5 6 7 8 9 10 11"
juanpe@jpdeb2:~/kernel/linux-source-4.9$ ls -l ..
total 342500
drwxr-xr-x  2 juanpe juanpe        21 oct  1 09:37 configs
-rw-r--r--  1 juanpe juanpe      2878 oct  2 09:21 linux-4.9.110-1_4.9.110-1-1_amd64.changes
-rw-r--r--  1 juanpe juanpe      1353 oct  2 09:21 linux-4.9.110-1_4.9.110-1-1.debian.tar.gz
-rw-r--r--  1 juanpe juanpe      1134 oct  2 09:21 linux-4.9.110-1_4.9.110-1-1.dsc
-rw-r--r--  1 juanpe juanpe 141384410 oct  2 08:50 linux-4.9.110-1_4.9.110-1.orig.tar.gz
-rw-r--r--  1 juanpe juanpe  10382700 oct  2 09:18 linux-headers-4.9.110-1_4.9.110-1-1_amd64.deb
-rw-r--r--  1 juanpe juanpe   7783044 oct  2 09:18 linux-image-4.9.110-1_4.9.110-1-1_amd64.deb
-rw-r--r--  1 juanpe juanpe  95573034 oct  2 09:21 linux-image-4.9.110-1-dbg_4.9.110-1-1_amd64.deb
-rw-r--r--  1 juanpe juanpe    869814 oct  2 09:18 linux-libc-dev_4.9.110-1-1_amd64.deb
drwxr-xr-x 25 juanpe juanpe      4096 oct  2 09:21 linux-source-4.9
-rw-r--r--  1 juanpe juanpe  94699084 oct  1 08:27 linux-source-4.9.tar.xz
juanpe@jpdeb2:~/kernel/linux-source-4.9$
```

Procedemos a instalar con `dpkg` el paquete `linux-image-4.9.110-1_4.9.110-1-1_amd64.deb`:
``` bash
sudo dpkg -i ../linux-image-4.9.110-1_4.9.110-1-1_amd64.deb
```
Y reiniciamos:
``` bash
sudo reboot
```
