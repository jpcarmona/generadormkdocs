# MkDocs

En este post veremos como crear páginas estáticas con MkDocs y luego desplegarlas con GitHubPages en un entorno Debian Stretch.

## Instalación

* Antes de instalar algo en Entornos Debian:
```bash
sudo apt update
```
* Instalamos Python y Pip:
```bash
sudo apt-get install python3.5
sudo apt-get install python3-pip
```
* `mkdocs build` - Build the documentation site.
* `mkdocs help` - Print this help message.

## Project layout

    mkdocs.yml    # The configuration file.
    docs/
        index.md  # The documentation homepage.
        ...       # Other markdown pages, images and other files.

Para más documentación visita:  
[mkdocs.org](https://www.mkdocs.org)  
[pages.github.com](https://help.github.com/categories/github-pages-basics)  