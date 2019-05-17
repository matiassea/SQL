# SQL
SQL commands

password: MATIAS
show databases;
CREATE DATABASE asignacion; Crea una nueva DataBase
show databases; Muestra las DataBase
use asignacion; esto es para empezar a trabajar la Tabla
show tables; muestra las Tablas, dentro de la DataBase




1) NOT NULL permite que un campo no pueda estar sin completar, es distinto NULO a EMPTY.
2) INTEGER UNSIGNED permite que no existan signos, de forma que los numeros siempre seran positivos.
3) DATO IMPORTANTE: mysql no detecta cuando los datos de AUTO_INCREMENT han sido borrados, por tanto seguira con el ultimo dato que guardo.
4) DEFAULT [valor por defecto]: Si no introducimos ningun dato, mySQl automaticamente le dara al campo el valor de DEFAULT.

- La diferencia entre CHAR y VARCHAR es que en el primer tipo de dato se asigna un valor en memoria por defecto dependiendo el tamaño de  espacios que sean asignados, en cambio, VARCHAR va llenando esos campos en memoria conforme se tengan los datos en el campo.

5) COMMENT: Comentario a la columna que solo es visible para quien este manejando la base de datos
- Para imagenes asignamos VARCHAR, NOTA: no se guarda la imagen como tal, guardamos el url del origen de la imagen
6) FLOAT es utilizado para calculos precisos, DOUBLE puede ser aplicado de forma simple a los precios de una libreria (en este caso)
7) DOUBLE (espacios que podremos llenar, espacios asignados para numeros decimales)
8) TEXT permite agregar texto, grandes cantidades de caracteres
9) TINYINT: Numérico que admite solo “1” o “0”, también llamado bandera.
10) TINYTEXT, TEXT, BIGTEXT: Textos de diferente cantidad de espacios soportados, de mas pocos a mas grandes respectivamente.

Comando auto_increment:

Ventajas
- Son fáciles de definir, ya que no requieren análisis profundo (y por ende tiene a descuidarse la consistencia).
- Ocupan menos espacio
- Se realizan JOINS rápidos (ya que la evaluación es a nivel de binarios), y por ende pueden obtenerse mejores performances en ciertos casos.

Desventajas
- No se puede hacer integración ni consolidación de sistemas sin complejos procesos de migración de datos con validaciones muy elaboradas.
- Poco flexibles: la clave es la lógica de operaciones/negocio, si por cualquier motivo quieres cambiarla, tendrías que cambiar todas las tablas, lo cual será un proceso costoso.
- Normalización: las tablas no están completamente normalizadas porque al añadir un campo adicional (y realmente innecesario para identificar una fila) hay varias claves candidatas.


DATE solo incluye fecha, pero no hora. DATE usa el formato ‘YYYY-MM-DD’. Con un rango de ‘1000-01-01’ a ‘9999-12-31’.
DATETIME incluye fecha y hora, Usa el formato ‘YYYY-MM-DD HH:MM:SS’. Con un rango de ‘1000-01-01 00:00:00’ a ‘9999-12-31 23:59:59’.
TIMESTAMP incluye fecha y hora. Con un rango de ‘1970-01-01 00:00:01’ UTC a ‘2038-01-19 03:14:07’ UTC.

### String type

https://dev.mysql.com/doc/refman/8.0/en/string-type-overview.html



### DATETIME and TIMESTAMP

DATE solo incluye fecha, pero no hora. DATE usa el formato ‘YYYY-MM-DD’. Con un rango de ‘1000-01-01’ a ‘9999-12-31’.
DATETIME incluye fecha y hora, Usa el formato ‘YYYY-MM-DD HH:MM:SS’. Con un rango de ‘1000-01-01 00:00:00’ a ‘9999-12-31 23:59:59’.
TIMESTAMP incluye fecha y hora. Con un rango de ‘1970-01-01 00:00:01’ UTC a ‘2038-01-19 03:14:07’ UTC.

https://dev.mysql.com/doc/refman/8.0/en/datetime.html
https://dev.mysql.com/doc/refman/8.0/en/date-and-time-type-overview.html
https://dev.mysql.com/doc/refman/8.0/en/data-types.html




