# Proyecto fin de curso 2º de ASIR - Gestión de creación de infraestrucutra, configuración y administración de software con AWX

<hr class="h3">

## Introducción

Hablar sobre AWX, Ansible, la automatización de tareas, etc...

### Objetivos de este proyecto

<hr class="h3">

## Requisitos

Para llevar a cabo el funcionamiento de este proyecto se hará uso de distintas tecnologías de sofware libre, se recomendaría tener conocimientos de algunas de estas tecnologías listadas a continuación. Además necesitaremos una infraestructura con OpenStack, en mi caso utilizo la de mi instituto.

### Tecnologías utilizadas

* [Docker](https://docs.docker.com/get-started/) - La versión Community Edition "CE:
``` bash
$ docker --version
Docker version 18.09.6, build 481bc77
```
* [Python3-pip](https://packaging.python.org/guides/installing-using-pip-and-virtual-environments/) :
``` bash
$ python3 -m pip --version
pip 19.1.1 from /home/user/.local/lib/python3.6/site-packages/pip (python 3.6)
```
* [Ansible](https://docs.ansible.com/ansible/latest/index.html) :
``` bash
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
Esta herramienta de cloud-computing me la proporcionará mi instituto y en él desplegaremos el resto de infraestructura virtual.

#### Infraestructura virtual:

* Servidor DNS.
* Servidor Apache.
* Servidor MySQL.
* Servidor DOcker.

<hr class="h3">

## Forma de trabajo

En esta ocasión se trabajará con la herramienta `git` con un repositorio remoto alojado en [github](https://github.com/jpcarmona/proyectoawx) (este mismo repositorio).

Trabajaremos en local con un directorio definido de la siguiente manera:
``` bash
PROJECT_NAME="proyecto"
PROJECT_DIR="${HOME}/${PROJECT_NAME}"
mkdir -p $PROJECT_DIR
```

Descargamos repositorio para trabajar con él:
``` bash
PROJECT_REPO_NAME="proyectoawx"
PROJECT_REPO_URL="https://github.com/jpcarmona/proyectoawx.git"
git clone $PROJECT_REPO_URL ${PROJECT_DIR}/${PROJECT_REPO_NAME}
```

Para cada apartado se explicará el trabajo previo realizado para su posterior uso.

<hr class="h3">

## Ansible

### Inventarios

Los inventarios son los ficheros donde se definen los equipos a los cuales se le van a realizar las tareas indicadas en los playbooks.

* Ejemplo fichero inventario:
``` bash
# inventories/inventory.yml
---
all:
  vars:
    # Ansible commons all
    ansible_ssh_common_args: '-o StrictHostKeyChecking=no'
    ansible_python_interpreter: "{{ ansible_playbook_python }}"
    ansible_ssh_private_key_file: ~/.ssh/id_rsa
    ansible_ssh_transfer_method: scp
  children:
    servers:
      vars:
        ansible_user: ubuntu
        ansible_port: 22
      children:
        mainservers:
          hosts:
            server1:
              ansible_host: 172.22.0.1
            server2:
              ansible_host: 172.22.0.2
        secondaryservers:
          hosts:
            server3:
              ansible_host: 172.22.0.3
            server4:
              ansible_host: 172.22.0.4
    containers:
      vars:
        ansible_user: root
        ansible_port: 22122
      children:
        maincontainers:
          hosts:
            container1:
              ansible_host: 172.22.0.1
            container2:
              ansible_host: 172.22.0.2
        secondarycontainers:
          hosts:
            container3:
              ansible_host: 172.22.0.3
            container4:
              ansible_host: 172.22.0.4
```

En la definición del ejemplo hemos agrupados los equipos en grupos y a su vez dichos grupos mantienen difrentes variables comúnes de ansible.

Variables comúnes:
* ansible_host:
* ansible_user:
* ansible_port:


### Playbooks

### Variables de host

### Variables de grupo



### Creación de un rol

Para la creación de nuevos roles una buena práctica es utilizar un `role-skeleton`
ROL DE ANSIBLE PARA INSTALAR DOCKER

https://github.com/geerlingguy/ansible-role-docker.git

## AWX

### ¿ Qué es AWX ?

Explicación AWX... , contenedores que lo forman...

### Preparación previa a la instalación

En este apartado se explicará los pasos previos llevados a cabo para la posterior instalación de AWX.

Comentar que la instalación de esta herramienta puede ser realizada de 3 formas:

* Mediante Openshift
* Usando Kubernetes
* En local con Docker

En mi caso he optado por utilizar la instalación en local con Docker ya que es la forma mas sencilla.


* Descarga de repositorio de AWX:
``` bash
AWX_REPO_NAME="awx"
AWX_REPO_URL="https://github.com/ansible/awx.git"
git clone $REPO_URL ${PROJECT_DIR}/${REPO_NAME}
```

En este repositorio podemos encontrar el propio instalador oficial de AWX que se basa en el propio uso de ansible con `inventory`, `playbooks` y `roles`.

Lo primero que haremos será definir las variables del inventory:

* Creamos inventory base sin comentarios ni líneas en blanco:
``` bash
cd ${PROJECT_DIR}/${AWX_REPO_NAME}/installer
cp inventory inventory.backup
cat inventory.backup | grep -Ev "^#|^$" > inventory
```

* Definimos variables añadiendo algunas que estaban comentadas necesarias quedando el fichero de una forma similar a esta:
``` Python
---
all:
  vars:
    dockerhub_base: ansible
    awx_task_hostname: awxtask
    awx_web_hostname: awxweb
    # Para que no nos cree las imagenes de Docker
    use_container_for_build: false
    # Volumenes a montar en contenedores
    postgres_data_dir: /var/lib/awx/pgdocker
    project_data_dir: /var/lib/awx/projects
    # Renvío de puertos locales
    host_port: 80
    host_port_ssl: 443
    # Directorio que nos interesa para su posterior uso
    docker_compose_dir: /tmp/awxcompose
    # Configuraciones de los distintos servicios de AWX
    pg_port: 5432
    pg_database: pgname 
    pg_username: pguser
    pg_password: pgpass
    rabbitmq_password: rabbitmqpass
    rabbitmq_erlang_cookie: rabbitmqcookie
    admin_user: awxuser
    admin_password: awxpass
    secret_key: awxsecret
  hosts:
    localhost:
      ansible_connection: local
      # Establecemos ansible_python_interpreter con el del entorno virtual utilizado. Podemos utilizar la variable "{{ ansible_playbook_python }}" que es el entorno actual utilizado.
      ansible_python_interpreter: "{{ ansible_playbook_python }}"

```

!!! note ""
    * En mi caso he convertido el fichero inventory de tipo INI a YAML.
    * Las contraseñas deben ser distintas si se van a utilizar en un entorno de producción[(Ver Anexo 3)](#anexo-3).

Con esto ya podríamos ejecutar el playbook pero antes realizaremos una modificación en una tarea de un rol. Esta modificación consistirá en comentar la tarea que nos crea los contenedores en local al lanzar el playbook, ya que esta tarea no tiene la acción parametrizada y queremos realizar algunas acciones antes del depspliegue de AWX.

La tarea es `Start the containers` situada en `${PROJECT_DIR}/${AWX_REPO_NAME}/installer/roles/local_docker/tasks/compose.yml`. Además también comentaremos las dos últimas tareas de este fichero que para nuestro caso no nos sirve para nada y se nos mostrará un error debido a que no se van a crear los contenedores.

Este playbook nos generará varios ficheros en el directorio en la variable `docker_compose_dir` que constará de ficheros de configuración y de un fichero para levantar los contenedores con `docker-compose`.

* Antes que nada debemos tener permisos en el directorio de los volumenes:
``` bash
sudo mkdir -p /var/lib/awx/
sudo chown -R $USER. /var/lib/awx/
```

* Ejecutamos playbook teniendo previamente creado un entorno virtual de python3[(Ver Anexo 1)](#anexo-1) con ansible instalado:
``` bash
ansible-playbook -i inventory install.yml
```

Los fichero generados en el directorio `docker_compose_dir` (`/tmp/awxcompose`) podemos cifrarlos con Ansible Vault[(Ver Anexo 2)](#anexo-2) ya que contienen contraseñas y así poderlos subirlos a nuestro repositorio de github.

### Instalación

* Nos situamos en el directorio `docker_compose_dir` y ejecutamos `docker-compose`:
``` bash
cd /tmp/awxcompose
docker-compose up -d
```

![](../../img/proyecto/captura1.png)

### Creando un proyecto en AWX



<hr class="h3">

## Anexos

### Anexo 1

Creación entorno virtual de python3

* Instalamos el paquete de python3 que nos permite crear entornos virtuales:
``` bash
apt install python3-venv
```

* Creamos y activamos entorno virtual:
``` bash
python3 -m venv ${PROJECT_DIR}/entorno
source ${PROJECT_DIR}/entorno/bin/activate
```

* Instalamos ansible con pip(gestor de paquetes de python)
``` bash
pip install ansible
```

### Anexo 2

Cifrado con Ansible Vault

!!! note ""
    * Es necesario tener un entorno virtual de python3[(Ver Anexo 1)](#anexo-1) con Ansible instalado.

### Creación de ficheros cifrados

* Creamos fichero con contraseña que usaremos para cifrar los ficheros
``` bash
openssl rand -base64 30 > vault-password-file.txt
```

* Ciframos ficheros con Ansible Vault:
``` bash
ansible-vault encrypt --vault-password-file  vault-password-file.txt foo.yml bar.yml baz.yml
```

* Para descifrar los ficheros:
``` bash
ansible-vault decrypt --vault-password-file  vault-password-file.txt foo.yml bar.yml baz.yml
```

### Creación de contraseña cifradas

### Anexo 3

Creación de contraseña aleatorias

* Podemos crear contraseñas aleatorias con `openssl`:
``` bash
openssl rand -base64 30
```

!!! note ""
    * `30`: Número de caracteres a generar aleatoriamente.
    * `-base64`: Codificación de los caracteres.
