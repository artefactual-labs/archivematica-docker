Archivematica on docker 
========================


Usage:
-----

        docker compose up  -d

- Archivematica dashboard will be accessible at http://localhost:62080 with user test/test
- Storage service will be available at http://localhost:62081 with user test/test
- This folder contents will be available as transfer sources
- AIPs and DIPs are stored in their respective directories (AIPsStore/ and DIPsStore/ )



Known problems
--------------

- ElasticSearch fails to boot and shows this error:

```
ERROR: [1] bootstrap checks failed
[1]: max virtual memory areas vm.max_map_count [65530] is too low, increase to at least [262144]

```

This can be fixed with:
```
sudo sysctl -w vm.max_map_count=262144
```

Useful commands
---------------

- Checking the system logs

        # All services
        docker compose logs 
        # Only for a specific service
        docker compose logs archivematica-mcp-server


- Running manage.py commands:

        docker compose exec -i -t archivematica-dashboard python manage.py
        docker compose exec -i -t archivematica-storage-service python manage.py

- Taking mysql backups:

          docker compose exec -i -t mysql mysqldump -uroot -p12345 MCP > MCP.sql
          docker compose exec -i -t mysql mysqldump -uroot -p12345 SS > SS.sql

- Restoring mysql backups

          docker compose exec -T mysql mysql -uroot -p12345 MCP < MCP.sql
          docker compose exec -T mysql mysql -uroot -p12345 SS < SS.sql
          docker compose restart

- Remove all containers/volumes (cleanup)

          docker compose down -v

The AIPs and DIPs stored won't be removed.


---

Tested on:
 - Ubuntu 24.04
 - Windows 11 / [WSL]( https://learn.microsoft.com/en-us/windows/wsl/install )
