# Cifrado y firmas con GPG

INTRODUCCION llalala

## Generación, exportación e importación de claves

### Creación par de claves desatendido

* Primero establecemos un directorio temporal para la creación de claves:
``` bash
export GNUPGHOME="$(mktemp -d)"
```

* Creamos un fichero con la frase de paso para no exponerlo mas tarde en la generación en claro:
``` bash
cat << EOF > frasedepaso
frasedepaso
EOF
```

!!! note ""
	Obviamente esta no será mi frase de paso.

* Creamos fichero de configuración de GPG:
``` bash
cat << EOF > key_conf
	Key-Type: RSA
	Key-Length: 4096
	Subkey-Type: RSA
	Subkey-Length: 4096
	Name-Real: Juan Pedro Carmona Romero
	Name-Comment: iesgn 2019 SAD
	Name-Email: jpcarmona92@gmail.com
	Expire-Date: 365
EOF
```

!!! note ""
	Los párametros de configuración son bastantes intuitivos, así que no los voy a explicar, pero podemos ver el manual de creación de claves desatendido en [GNUGPG-manual](https://www.gnupg.org/documentation/manuals/gnupg/Unattended-GPG-key-generation.html#Unattended-GPG-key-generation).

* Creación par de claves:
``` bash
gpg --verbose --batch --pinentry-mode loopback --passphrase-file frasedepaso --generate-key key_conf
```

!!! note ""
	Utilizamos la opción `--batch` para generar la clave de forma desatendida mediante el fichero `key_conf` y la opción `--pinentry-mode loopback --passphrase-file frasedepaso` es para especificar la frase de paso mediante un fichero.

![](../../img/gpg/captura1.png)

Podemos ver que he utilizado `time` para enseñaros lo que tarda en generarse y os puede parecer raro que haya tardado solo 7 segundos ya que esto suele tardar varios minutos. La clave está en la generación de entropía que necesita GPG para la generación de claves. Esto lo explico a continuación.

### Generación de datos aleatorios para una fuente de entropía

* Instalación de paquete:
``` bash
apt install rng-tools
```

* Ejecución del demonio:
``` bash
rngd -r /dev/urandom
```

!!! note ""
	Una vez ejecutado el demonio no hará falta ejecutarlo más si vamos a generar varias claves.

### Exportación de clave a fichero

* Listamos las claves:
``` bash
gpg --list-secret-keys
```

![](../../img/gpg/captura2.png)

* Exportación de clave a un fichero:
``` bash
gpg --pinentry-mode loopback --passphrase-file frasedepaso \
--armor --export-secret-keys 'iesgn 2019' > juanpe_priv.key
```

!!! note ""
	* `--armor` : por defecto gpg exporta en binaro, de esta manera se exportará en texto plano.
	* `--export-secret-keys 'iesgn 2019'` : podemos utilizar como identificador para exportar la clave la huella, el nombre, el comentario o el email.

### Importación de clave desde fichero

Ahora si queremos mantener el par de claves en la base de datos(anillo de claves) de GPG personal de un usuario realizaremos lo siguiente:

* Importamos la clave desde un fichero:
``` bash
gpg --pinentry-mode loopback --passphrase frasedepaso --import juanpe_priv.key
```

!!! attention "Atención"
	* Utilizar otro terminal para que utilize como "GNUPGHOME" el de nuestro usuario y no el temporal que creamos anteriormente.
	* Si por casualidad hemos borrado por error el directorio `.gnupg` necesitamos reiniciar el agente de GPG, podemos hacerlo reiniciando la máquina o ejecutando `gpgconf --kill gpg-agent`.

## Servidores de claves

!!! note ""
	En este apartado tendremos que tener un poco de paciencia, ya que estos servidores no responden con buena fluidez.

### Exportación de clave a un servidor

* Añadiremos nuestra clave pública al servidor `pgp.rediris.es`:
``` bash
gpg --verbose --keyserver pgp.rediris.es --send-keys 6CDB8ABAB811462E0F10CA799817655FF0B0BF63
```

![](../../img/gpg/captura3.png) !!!!!! volver a hacer

!!! attention "Atención"
	* Necesitaremos como dependecia el paquete `dirmngr`.

### Revocar nuestra clave en el servidor

* Creamos clave de revocación:
``` bash
gpg --pinentry-mode loopback --passphrase frasedepaso --gen-revoke jpcarmona92@gmail.com > revocacion.txt
```

!!! note ""
	Nos preguntará de si estamos seguros de revocar la clave y la razón.

![](../../img/gpg/captura3.png) !!!!!! volver a hacer

* Añadimos la clave de revocación a la base de datos(anillo de claves) de GPG temporal:
``` bash
export GNUPGHOME="$(mktemp -d)"
gpg --pinentry-mode loopback --passphrase frasedepaso --import juanpe_priv.key
gpg --import revocacion.txt
```

!!! note ""
	Lo hacemos de esta manera si no queremos revocar localmente nuestra clave.

![](../../img/gpg/captura3.png) !!!!!! volver a hacer

* Enviamos revocación al servidor:
``` bash
gpg --verbose --keyserver hkps://pgp.rediris.es --send-keys 6CDB8ABAB811462E0F10CA799817655FF0B0BF63
```

!!! note ""
	Tenemos que utilizar como identificador la huella de la clave.

![](../../img/gpg/captura3.png) !!!!!! volver a hacer



* Para buscar claves mediante comandos:
gpg --keyserver pgp.rediris.es --search-keys 'Rafael Luque Clave para prácticas SAD'