# Kernel Linux

En este post veremos como configurar el kernel linux y adaptarlo a las necesidades mínimas de nuestra máquina.

## Instalación

Antes de instalar algo en Entornos Debian:  
``` bash
sudo apt update
```

Instalamos las herramientas básicas de compilación:
``` bash
sudo apt-get install build-essential ncurses-dev xz-utils libssl-dev bc
```

Instalamos el paquete del kernel:
``` bash
sudo apt-get install linux-source-4.9
```
Nos creará un fichero en /usr/src/linux-source-4.9.tar.bz2

Utilizamos un directorio donde trabajar:
``` bash
mkdir ~/kernel
cd ~/kernel
cp /usr/src/linux-source-4.9.tar.bz2 ./
tar -xJf linux-source-4.9.tar.bz2
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