
-- psql -U dba -d dba

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
