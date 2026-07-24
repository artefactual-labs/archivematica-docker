# Architecture

This branch has the Storage Service stripped down from the compose file. Is intended to deploy extra Archivematica pipelines against the same Storage Service

- It relies on an already deployed full stack ( SS + Dashboard + MCP-C/S )

- The extra instances need to use a different sharedDirectory folder defined in the .env file

- The new sharedDirectory folders need to be added as env vars (check archivematica/*-env files)
   
- This repo uses port 630** to avoid collisions when running in the same host.

- Tweak archivematica/bootstrap.yml as needed to point to the Storage service


Storage service configuration:
-------------------------------
   - Mounted the new shareDirectory in the ss ( Use https://rclone.org/commands/rclone_mount/  if the server is different)

      - "/home/santi/workspace/github/scollazo/secondinstance/secondSharedDirectory:/var/archivematica/secondSharedDirectory:rw"

   - Configure a processing location pointing to  /var/archivematica/secondSharedDirectory for the second pipeline (it should already be registered)



Caveats
-------
 - We need to make the currentlyprocessing folder available to the SS
    - Each pipeline needs configuration in the SS
    - If we mount it *from* the pipeline, the IO is mostly local, and only the copy from the TS and to the AIPstore is network-bound
    - Transfer Sources and AIPstores are shared between instances, but processingConfigs arent


 - Options to be considered:
      - use pipeline_local_filesystem
        - For each new pipeline, create a pipeline_local_filesystem location in the SS pointing to the pipeline watchedDirectory
        - Configure ssh for each new pipeline 


