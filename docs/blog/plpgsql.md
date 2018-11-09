# PL/SQL vs PL/PGSQL

En este post veremos las principales diferencias entre la programación en PL/SQL de Oracle y PL/PGSQL de Postgres.

## Triggers

Las principales diferencias encontradas a la hora de escribir un programa en PL/SQL y 
PL/PGSQL radica a la hora de crear un trigger.

Mientras que en PL/SQL tendría la siguiente estructura:

``` sql
CREATE OR REPLACE TRIGGER nombretrigger
(AFTER/BEFORE) (INSERT,UPDATE OR DELETE) ON tabla
FOR EACH (fila o sentencia)
BEGIN
	...
END;
/
```

En PL/PGSQL, no existe el trigger como tal, sino que creamos una función que hará
lo que deseemos que haga el trigger y posteriormente crearemos un trigger para 
llamar a esa función y le dirá cuando actuar. La estructura quedaría de la siguiente manera:

* Función:

``` sql
CREATE OR REPLACE FUNCTIO nombrefuncion RETURNS TRIGGER AS $nombretrigger$
DECLARE
	...
BEGIN
	...
END;
$nombretrigger$ LANGUAGE PLPGSQL
```

* Trigger:

``` sql
CREATE OR REPLACE nombretrigger
(AFTER OR BEFORE)(INSERT,UPDATE OR DELETE) ON tabla
FOR EACH(FILA O SENTENCIA) 
EXECUTE FUNCTION nombrefuncion;
```

## Cursores

Por otro lado, también cambia la forma de recorrer un CURSOR con un FOR. 
Mientras que en PL/SQL se crea el CURSOR y luego se recorre:

``` sql
CURSOR c_cursor
IS
SELECT campo1, campo2
FROM tabla;
...

FOR i IN c_cursor LOOP
    ...
END LOOP;
```

En PL/PGSQL sería:

``` sql
FOR c_cursor IN SELECT campo1, campo2 FROM tabla LOOP;
    ...
END LOOP;
```

##

!!! note ""
	Por último, aunque un poco menos importante, a la hora de crear funciones, 
	el "IS" para declarar variables y cursores en PL/SQL, es sustituido por "DECLARE" en PL/PGSQL.