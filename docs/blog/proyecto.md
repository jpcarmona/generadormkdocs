# Proyecto fin de curso 2º de ASIR - Gestión de creación de infraestrucutra, configuración y administración de software con AWX

## Introducción

Hablar sobre AWX, Ansible, la automatización de tareas, etc...

### Objetivos de este proyecto



## Requisitos

Para llevar a cabo el funcionamiento de este proyecto se hará uso de distintas tecnologías de sofware libre, se recomendaría tener conocimientos de algunas de estas tecnologías listadas a continuación. Además necesitaremos una infraestructura con OpenStack, en mi caso utilizo la de mi instituto.

### Tecnologías utilizadas

* [Docker](https://docs.docker.com/get-started/) - La versión Community Edition "CE:
```
$ docker --version
Docker version 18.09.6, build 481bc77
```
* [Python3-pip](https://packaging.python.org/guides/installing-using-pip-and-virtual-environments/) :
```
$ python3 -m pip --version
pip 19.1.1 from /home/user/.local/lib/python3.6/site-packages/pip (python 3.6)
```
* [Ansible](https://docs.ansible.com/ansible/latest/index.html) :
```
$ ansible --version
ansible 2.8.0
  config file = None
  configured module search path = ['/home/user/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
  ansible python module location = /home/user/env/lib/python3.6/site-packages/ansible
  executable location = /home/user/env/bin/ansible
  python version = 3.6.5 (default, Apr  1 2018, 05:46:30) [GCC 7.3.0]
```
* [AWX](https://github.com/ansible/awx)

### Infraestructura

* En nuestro equipo local de desarrollo donde trabajaremos en este proyecto instalaremos la herramienta AWX

* Servidor con Openstack:
Esta herramienta de cloud-computing me la proporcionará mi instituto.

## Forma de trabajo

En esta ocasión se trabajará con la herramienta `git` con un repositorio remoto alojado en [github](https://github.com/jpcarmona/proyectoawx) (este mismo repositorio).

Trabajaremos en local con un directorio definido de la siguiente manera:
```
PROJECT_NAME="proyecto"
PROJECT_DIR="${HOME}/${PROJECT_NAME}"
mkdir -p $PROJECT_DIR
```

Descargamos repositorio para trabajar con él:
```
PROJECT_REPO_NAME="proyectoawx"
PROJECT_REPO_URL="https://github.com/jpcarmona/proyectoawx.git"
git clone $PROJECT_REPO_URL ${PROJECT_DIR}/${PROJECT_REPO_NAME}
```

Para cada apartado se explicará el trabajo previo realizado para su posterior uso.

## AWX

### ¿ Qué es AWX ?

Explicación AWX... , contenedores que lo forman...

### Preparación previa

En este apartado se explicará los pasos previos llevados a cabo para la posterior instalación de AWX.

Comentar que la instalación de esta herramienta puede ser realizada de 3 formas:

* Mediante Openshift
* Usando Kubernetes
* En local con Docker

En mi caso he optado por utilizar la instalación el local con Docker ya que es la forma mas sencilla y viable.


* Descarga de repositorio de AWX:
```
AWX_REPO_NAME="awx"
AWX_REPO_URL="https://github.com/ansible/awx.git"
git clone $REPO_URL ${PROJECT_DIR}/${REPO_NAME}
```

En este repositorio podemos encontrar el propio instalador oficial de AWX que se basa en el propio uso de ansible con `inventory`, `playbooks` y `roles`.

Lo primero que haremos será definir las variables del inventory:

* Creamos inventory base sin comentarios ni líneas en blanco:
```
cd ${PROJECT_DIR}/${AWX_REPO_NAME}/installer
cp inventory inventory.backup
cat inventory.backup | grep -Ev "^#|^$" > inventory
```

* Definimos variables añadiendo algunas que estaban comentadas necesarias quedando el fichero de una forma similar a esta:
```
#<-- Establecemos ansible_python_interpreter con el del entorno virtual utilizado
localhost ansible_connection=local ansible_python_interpreter="/home/usuario/proyecto/entorno/bin/python3"
#-->
[all:vars]
dockerhub_base=ansible
awx_task_hostname=awxtask
awx_web_hostname=awxweb
#<-- Volumenes a montar en contenedores
postgres_data_dir=/var/lib/awx/pgdocker
project_data_dir=/var/lib/awx/projects
#-->
#<-- Renvío de puertos locales
host_port=80
host_port_ssl=443
#-->
#<-- Directorio que nos interesa para su posterior uso
docker_compose_dir=/tmp/awxcompose
#-->
#<-- Configuraciones de los distintos servicios de AWX
pg_username=pguser
pg_password=pgpass
pg_database=pgname
pg_port=5432
rabbitmq_password=rabbitmqpass
rabbitmq_erlang_cookie=rabbitmqcookie
admin_user=awxuser
admin_password=awxpass
secret_key=awxsecret
#-->
#<-- Para que no nos cree las imagenes de Docker
use_container_for_build=false
#-->
```

Con esto ya podríamos ejecutar el playbook pero antes realizaremos una modificación en una tarea de un rol. Esta modificación consistirá en comentar la tarea que nos crea los contenedores en local al lanzar el playbook, ya que esta tarea no tiene la acción parametrizada.

La tarea es "Start the containers" situada en "${PROJECT_DIR}/${AWX_REPO_NAME}/installer/roles/local_docker/tasks/compose.yml". Además también comentaremos las dos últimas tareas de este fichero que para nuestro caso no nos sirve para nada y se nos mostrará un error debido a que no se van a crear los contenedores.

Este playbook nos generará varios ficheros en el directorio en la variable `docker_compose_dir` que constará de ficheros de configuración y de un fichero para levantar los contenedores con `docker-compose`.

* Antes que nada debemos tener permisos en el directorio de los volumenes:
```
sudo mkdir -p /var/lib/awx/
sudo chown -R $USER. /var/lib/awx/
```

* Ejecutamos playbook teniendo previamente creado un entorno virtual de python3[Anexo 1] con ansible instalado:
```
ansible-playbook -i inventory install.yml
```

*** Explicacion subida de dockercompose a github

*** Explicacion cifrado contraseñas con ansible-vault

### Instalación

## Anexos

### Anexo 1 - Creación entorno virtual de python3

* Instalamos el paquete de python3 que nos permite crear entornos virtuales:
```
apt install python3-venv
```

* Creamos y activamos entorno virtual:
```
python3 -m venv ${PROJECT_DIR}/entorno
source ${PROJECT_DIR}/entorno/bin/activate
```

* Instalamos ansible con pip(gestor de paquetes de python)
```
pip install ansible
```