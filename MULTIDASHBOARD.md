# Architecture

:q- One full stack
    SS + Dashboard + MCP-C/S

- Extra instances
   - Different sharedDirectory in .env
        - Updated archivematica/env files
 
   - Use 63080 port in the same server
   - Mounted the new shareDirectory in the ss

      - "/home/santi/workspace/github/scollazo/secondinstance/secondSharedDirectory:/var/archivematica/secondSharedDirectory:rw"

   - SS configured with /var/archivematica/secondSharedDirectory as processing folder for the second pipeline


To be tested:
 - Use .sharedDirectory folder for the new env
 - Mount it with a different name in the SS (?)

Caveats:
 - We need to make the currentlyprocessing folder available to the SS
    - Each pipeline needs configuration in the SS:
    - If we mount it *from* the pipeline, the IO is mostly local, and only the copy from the TS and to the AIPstore is network-bound (Use rclone mounts ( https://rclone.org/commands/rclone_mount/ )
    - Transfer Sources and AIPstores are shared between instances


 - Options to be considered:
      - use pipeline_local_filesystem
        - For each new pipeline, create a pipeline_local_filesystem location in the SS pointing to the pipeline watchedDirectory
        - Configure ssh for each new pipeline 


