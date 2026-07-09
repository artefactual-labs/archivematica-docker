#!/usr/bin/env sh

set -eux


# Set up temporal database schema.
temporal-sql-tool --plugin mysql8 --ep mysql -u archivematica -p 3306 -pw demo --db temporal setup-schema -v 0.0
temporal-sql-tool --plugin mysql8 --ep mysql -u archivematica -p 3306 -pw demo --db temporal update-schema --schema-name mysql/v8/temporal

# Set up visibility database schema.
temporal-sql-tool --plugin mysql8 --ep mysql -u archivematica -p 3306 -pw demo --db temporal_visibility setup-schema -v 0.0
temporal-sql-tool --plugin mysql8 --ep mysql -u archivematica -p 3306 -pw demo --db temporal_visibility update-schema --schema-name mysql/v8/visibility
