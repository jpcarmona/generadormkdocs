# MkDocs

En este post veremos como crear páginas estáticas con MkDocs en un entorno Debian Stretch y luego desplegarlas con GitHubPages .

## Instalación

Antes de instalar algo en Entornos Debian:  

	sudo apt update

Instalamos Python y Pip ya que MkDocs está desarrollado en Python:

	sudo apt-get install python3.5
	sudo apt-get install python3-pip

Instalamos el creador de entornos virtuales de Python para instalar los modulos necesarios en nuestro entorno:

	sudo apt-get install python3-venv

* Creamos el entorno:  
	
python3 -m venv mkdocs_env

* Activamos el entorno:  

source entorno1/bin/activate


## Project layout

    mkdocs.yml    # The configuration file.
    docs/
        index.md  # The documentation homepage.
        ...       # Other markdown pages, images and other files.

Para más documentación visita:  
[mkdocs.org](https://www.mkdocs.org)  
[pages.github.com](https://help.github.com/categories/github-pages-basics)  

