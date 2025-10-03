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
- The name of the elasticsearch data volume has been changed to match Elasticseach version. Check [UPGRADE.md](UPGRADE.md)
- Archivematica [audit log](https://github.com/artefactual-labs/auditmatica/blob/main/README.md#usernames) is now enabled by default
- Archivematica's backlog and appraisal tabs have been disabled, to better mimic the OAIS model in Archivematica


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


---

Tested on:
 - Ubuntu 24.04
 - Windows 11 / [WSL]( https://learn.microsoft.com/en-us/windows/wsl/install )
