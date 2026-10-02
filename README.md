Archivematica on docker
========================


Usage:
-----


- First, add your UID to the .env file with:

        echo UID=$(id -u) >> .env

  Archivematica will run as the user you launch it with.

- Then, start docker using

        docker compose up  -d

- Archivematica dashboard will be accessible at http://localhost:62080 with user test/test
- Storage service will be available at http://localhost:62081 with user test/test
- The Transfers/ folder contents will be available as transfer sources
- AIPs and DIPs are stored in their respective directories (AIPsStore/ and DIPsStore/ )



Known problems
--------------

- Elasticsearch and the Archival storage tab are disabled by default due to high resource use

They can be enabled by adding the following snippet to the .env file:

       # Enable Archival Storage tab (disabled by default)
       COMPOSE_PROFILES=search
       AM_SEARCH_ENABLED=true


- In case ElasticSearch fails to boot and shows this error:

```
ERROR: [1] bootstrap checks failed
[1]: max virtual memory areas vm.max_map_count [65530] is too low, increase to at least [262144]

```

This can be fixed with:
```
sudo sysctl -w vm.max_map_count=262144
```

- On Mac computers with ARM cpu, elasticsearch container fails to boot. This will be addressed in
the [next archivematica release](https://github.com/archivematica/Issues/issues/1752)

Environment
-----------

There is a example.env file with the available variables. In order to override them, copy it to .env or set your own ```COMPOSE_ENV_FILES```

Custom mounts for transfer sources or AIPstores can be added using a custom compose file

    services:
      archivematica-storage-service:
        volumes:
          - /var/other/mount:/home/local_ts

And launching the project using ````docker compose -f docker-compose.yml -f custom.yml```` , or setting the ````COMPOSE_FILE```` environment variable.

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

          docker compose exec -i -t mysql mysqldump -uroot MCP > MCP.sql
          docker compose exec -i -t mysql mysqldump -uroot SS > SS.sql

- Restoring mysql backups

          docker compose exec -T mysql mysql -uroot MCP < MCP.sql
          docker compose exec -T mysql mysql -uroot SS < SS.sql
          docker compose restart

- Remove all containers/volumes (cleanup)

          docker compose down -v

The AIPs and DIPs stored won't be removed.


---

Tested on:
 - Ubuntu 24.04
 - Windows 11 / [WSL]( https://learn.microsoft.com/en-us/windows/wsl/install )
