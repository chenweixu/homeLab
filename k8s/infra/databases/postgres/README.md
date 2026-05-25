
```sql
CREATE USER wait WITH PASSWORD 'password';
```

```sh
export PGPASSWORD='password'

pg_dump -h 192.168.5.9 -U wait -d db1 -C > db1_with_db.sql
psql -h 192.168.5.30 -p 5432 -U postgres -d postgres -f db1_with_db.sql

pg_dump -h 192.168.5.9 -U wait -d test -C > test_with_db.sql
psql -h 192.168.5.30 -p 5432 -U postgres -d postgres -f test_with_db.sql
```
