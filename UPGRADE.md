Upgrade from Archivematica 1.17.x
---------------------------------


Archivematica 1.18.x uses Elasticserch 8.x.

In order to migrate from Elasticsearch 6.x, the following process can be followed:

- Check Elasticsearch 6.x index contents, and note them:

      curl -X POST "http://localhost:62002/_flush?pretty"
      for index in aips aipfiles transfers transferfiles; do
        echo "$index: $(curl -X GET -s "localhost:62002/$index/_count?pretty" | jq '.count')"
      done

- Stop the Archivematica 1.17 services before the upgrade:

        docker compose down

- Update your branch

        git pull --rebase

- Start the system in upgrade mode:

       docker compose -f docker-compose.yml -f upgrade/docker-compose-es8-upgrade.yml up -d
  This will take care of migrating your Elasticsearch 6.x indexes into ElasticSearch 8.x

- Verify that all the indexes were properly migrated

      curl -X POST "http://localhost:62002/_flush?pretty"
       for index in aips aipfiles transfers transferfiles; do
        echo "$index: $(curl -X GET -s "localhost:62002/$index/_count?pretty" | jq '.count')"
       done

- Stop Archivematica 1.18 upgrade mode:

      docker compose -f docker-compose.yml -f upgrade/docker-compose-es8-upgrade.yml down

- Remove old elasticsearch volume (optional)

      docker compose volume rm am_elasticseach_data

- From now on, the system can be started as usual

      docker compose up -d
