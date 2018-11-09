#!/bin/bash

git add * 2>/dev/null
echo "Comentario1:"
read comentario1
git commit -am "$comentario1"
echo "pass github:"
read pass
(expect -c "
set timeout -1
spawn git push
expect \"*passphrase*\"
send \"$pass\r\"
expect \"*master*\"

"
exit)
mkdocs build -d web
cd web
git add * 2>/dev/null
git commit -am "$comentario1"
(expect -c "
set timeout -1
spawn git push
expect \"*passphrase*\"
send \"$pass\r\"
expect \"*master*\"

"
exit)
cd ..
