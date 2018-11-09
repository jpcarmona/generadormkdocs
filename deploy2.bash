#!/bin/bash

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