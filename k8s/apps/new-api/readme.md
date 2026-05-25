

```sql
CREATE DATABASE newapi OWNER wait;
GRANT ALL PRIVILEGES ON DATABASE newapi TO wait;

\c newapi
alter schema public owner to wait;
GRANT ALL ON SCHEMA public TO wait;
```
