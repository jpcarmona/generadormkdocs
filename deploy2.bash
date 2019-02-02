#!/bin/bash

source ~/entornos/mkdocs_env/bin/activate

python3 genindex.py

git add * 2>/dev/null
echo "Comentario1:"
read comentario1
git commit -am "$comentario1"
git push
mkdocs build -d web
cd web
git add * 2>/dev/null
git commit -am "$comentario1"
git push
cd ..
