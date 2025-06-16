CREATE DATABASE MCP CHARACTER SET utf8 COLLATE utf8_unicode_ci;
CREATE DATABASE SS CHARACTER SET utf8 COLLATE utf8_unicode_ci;
GRANT ALL ON MCP.* TO 'archivematica'@'%';
GRANT ALL ON SS.* TO 'archivematica'@'%';
