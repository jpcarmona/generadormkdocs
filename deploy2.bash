#!/usr/bin/env bash

__dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

MKDOCS_ENV="${HOME}/envs-py3/mkdocs"

# GENERATE VIRTUALENV
python3 -m venv ${MKDOCS_ENV}
source ${MKDOCS_ENV}/bin/activate
pip3 install -r ${__dir}/requeriments.txt

# GENERATE INDEX WEB
python3 ${__dir}/genindex.py

# PUSH GIT REPO MKDOCS
git add . 2>/dev/null
echo "Comentario1:"
read comentario1
git commit -am "$comentario1"
git push
# BUILD WEB PAGE
mkdocs build -d web
# PUSH GIT REPO GITHUBPAGE WEB
git clone git@github.com:jpcarmona/web.git
cd web
git add . 2>/dev/null
git commit -am "$comentario1"
git push
cd ..
