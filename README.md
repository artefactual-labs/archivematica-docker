Archivematica on docker 
========================


Usage:
-----

              docker compose up  -d

- Archivematica dashboard will be accessible at http://localhost:62080 with user test/test
- Storage service will be available at http://localhost:62081 with user test/test
- This folder contents will be available as transfer sources
- AIPs and DIPs are stored in their respective directories (AIPsStore/ and DIPsStore/ )


For upgrades, check the [UPGRADE.md](UPGRADE.md) file


What's new in 1.18.x ?
----------------------



- [Archivematica 1.18.x changelog](https://wiki.archivematica.org/Archivematica_1.18.0_and_Storage_Service_0.24.0_release_notes_)

Regarding this repository, there are a few changes too:

- We can configure default values using a .env file, check .env-test for an example.
- The docker volumes used for archivematica_pipeline_data and archivematica_storage_service_staging volumes are now configured as local folders, and made avalable to the containers through bind mounts.
This allows to put them in a different filesystem with more space without having to reconfigure docker volumes.
- Elasticsearch has been moved to extras/ due to it's high memory needs.
- Archivematica [audit log](https://github.com/artefactual-labs/auditmatica/blob/main/README.md#usernames) is now enabled by default
- Enduro and Aipscan has been added to the stack

Known problems
--------------

- MCPServer fails to boot and shows

```
PermissionError: [Errno 13] Permission denied: '/var/archivematica/sharedDirectory/www/AIPsStore/transferBacklog'
```

This is due to the permissions used by the user running archivematica inside the docker container. An easy workaround is ```chmod 777 AIPsStore```



Useful commands
---------------

- Checking the system logs

        # All services
        docker compose logs 
        # Only for a specific service
        docker compose logs archivematica-mcp-server


- Running manage.py commands:

        docker compose exec -i -t archivematica-dashboard python3 -m archivematica.dashboard.manage
        docker compose exec -i -t archivematica-storage-service python3 -m archivematica.storage_service.manage

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

## Using extras

The repository contains an extras/ folder with Archivematica adjacent projects: [Enduro](https://github.com/artefactual-labs/enduro) and [Aipscan](https://github.com/artefactual-labs/aipscan)

In order to use them, append them to the COMPOSE_FILE environment variable as in

        # Bash shell (most of you)
        export COMPOSE_FILE="docker-compose.yml:extras/compose-enduro.yml:extras/compose-aipscan.yml"

        # Fish shell
        set -lx COMPOSE_FILE "docker-compose.yml:extras/compose-enduro.yml:extras/compose-aipscan.yml"

If you don't want both, remove the pertinent ones from the COMPOSE_FILE variable


## Enabling Elasticsearch

If you want to enable Elasticsearch, besides appending it in the COMPOSE_FILE, you also need to enable the it in the .env file:

        echo AM_SEARCH_ENABLED=true | tee -a .env

        # Bash shell
        export COMPOSE_FILE="docker-compose.yml:extras/compose-elasticsearch.yml"

        # Fish shell
        set -lx COMPOSE_FILE "docker-compose.yml:extras/compose-elasticsearch.yml"

If ElasticSearch fails to boot and shows this error:

```
ERROR: [1] bootstrap checks failed
[1]: max virtual memory areas vm.max_map_count [65530] is too low, increase to at least [262144]

```

This can be fixed with:

```
sudo sysctl -w vm.max_map_count=262144
```

## Running as a different user

By default, the Archivematica and Aipscan containers run under the user id 1000.

If the current user has a different uid (you can check with ```id -u```), run the following commands to configure your local user:

        echo UID=$(id -u) | tee -a .env
        echo "archivematica:x:$(id -u):$(id -u)::/var/lib/archivematica:/bin/bash"  > .custom-passwd
        echo "archivematica:x:$(id -u):" > .custom-group
        echo "aipscan:x:$(id -u):$(id -u)::/var/lib/aipscan:/bin/bash"  > .aipscan-passwd
        echo "aipscan:x:$(id -u):" > .aipscan-group


And add the extra compose files to the COMPOSE_FILE:

        # Bash shell
        export COMPOSE_FILE="docker-compose.yml:extras/compose-aipscan.yml:extras/compose-custom-user.yml:extras/compose-aipscan-custom-user.yml"
        # Fish shell
        set -lx COMPOSE_FILE "docker-compose.yml:extras/compose-aipscan.yml:extras/compose-custom-user.yml:extras/compose-aipscan-custom-user.yml"

## Port allocation

With all extras enabled but ElasticSearch, the system has a total memory allocation around 4 Gb

Services can be accessed at:

| Service         | Link      | External port  | Internal port |
|-----------------|-----------|----------------|---------------|
| Archivematica   | [Archivematica dashboard](http://localhost:62080) |    62080      |     8000      |
| Storage Service | [Storage service](http://localhost:62081)   |    62081        |     8000      |
| Enduro Dashboard|   [Enduro](http://localhost:9000)|    9000        |     9000      |
| AipScan      |   [Aipscan](http://localhost:5001)   |    5001        |     5001      |
| Temporal UI     |    [Temporal UI](http://localhost:7440)|    7440        |     7440      |
| SeaWeed UI (S3)     |  [Seaweed (S3)](http://localhost:7461)  |    7461        |     7461      |



---

Tested on:
 - Ubuntu 24.04
 - Windows 11 / [WSL]( https://learn.microsoft.com/en-us/windows/wsl/install )
