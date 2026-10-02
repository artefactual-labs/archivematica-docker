#!/bin/bash
#
# Runs only on the first initialisation of an empty MySQL data directory.
#
# NOTE: the Percona entrypoint SOURCES these files - process_init_file() runs
# `. "$f"` for every *.sh, regardless of the executable bit. Shell options must
# therefore stay inside a subshell; leaving `set -u` active in the entrypoint
# shell makes it abort afterwards with:
#   /docker-entrypoint.sh: line 206: MYSQL_ONETIME_PASSWORD: unbound variable
#
# A shell script is used instead of a .sql file because database and user names
# come from the environment, and plain .sql files are piped straight to the
# mysql client, so they cannot be parameterised.
(
set -euo pipefail

mysql --protocol=socket -uroot <<SQL
CREATE DATABASE IF NOT EXISTS \`${ARCHIVEMATICA_MCP_DB_NAME}\` CHARACTER SET utf8 COLLATE utf8_unicode_ci;
CREATE DATABASE IF NOT EXISTS \`${ARCHIVEMATICA_SS_DB_NAME}\` CHARACTER SET utf8 COLLATE utf8_unicode_ci;
GRANT ALL ON \`${ARCHIVEMATICA_MCP_DB_NAME}\`.* TO '${MYSQL_USER}'@'%';
GRANT ALL ON \`${ARCHIVEMATICA_SS_DB_NAME}\`.* TO '${MYSQL_USER}'@'%';
SQL
)
