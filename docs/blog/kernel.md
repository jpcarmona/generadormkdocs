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

Instalamos las bibliotecas de desarrollo para configurar el kernel:
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

Editamos la línea "EXTRAVERSION":

``` bash
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
Con esto nos habrá configurado el fichero "~/kernel/linux-source-4.9/.config" automáticamente.