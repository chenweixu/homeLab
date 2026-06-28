

```sh
docker run --rm -it harbor.chenwx.top/docker.io/postgres:18.4 bash
docker run --rm -it harbor.chenwx.top/chenwx/postgres-cwx:18.4 bash

docker build -t harbor.chenwx.top/chenwx/postgres-cwx:18.4 -f dockerfile .
```


## pre-sql
```sql

CREATE DATABASE gatus OWNER wait;
GRANT ALL PRIVILEGES ON DATABASE gatus TO wait;

\c gatus
alter schema public owner to wait;
GRANT ALL ON SCHEMA public TO wait;

--=================================================================

CREATE DATABASE db1 OWNER wait;
GRANT ALL PRIVILEGES ON DATABASE db1 TO wait;

\c db1
alter schema public owner to wait;
GRANT ALL ON SCHEMA public TO wait;

--=================================================================

CREATE DATABASE hoppscotch OWNER wait;
GRANT ALL PRIVILEGES ON DATABASE hoppscotch TO wait;

\c hoppscotch
alter schema public owner to wait;
GRANT ALL ON SCHEMA public TO wait;
--=================================================================

CREATE DATABASE nocodb OWNER wait;
GRANT ALL PRIVILEGES ON DATABASE nocodb TO wait;

CREATE DATABASE test OWNER wait;

-- pg vector db
CREATE DATABASE ops_data OWNER wait;
GRANT ALL PRIVILEGES ON DATABASE ops_data TO wait;

```
