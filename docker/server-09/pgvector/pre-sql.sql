
-- psql -U dba -d dba

create user wait with password 'passw0rd';

CREATE DATABASE ops_data OWNER wait;
GRANT ALL PRIVILEGES ON DATABASE ops_data TO wait;
