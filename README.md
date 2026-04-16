# docker-mongodb-online-backup

Simple docker container to make **consistent** backups of a live MongoDB database on a schedule.

This container does not include any functionality for retaining multiple backups, backing up to remote destinations, or naming backups based on timestamps. Rather, it is intended for use in conjunction with a backup system such as restic.

**WARNING:** Do not use this to back up a Sharded Cluster. This tool does not guarantee consistency for Shared Clusters.

## Environment variables:

### `CRON`

Specify the backup schedule in CRON syntax. Default value is "0 * * * *", which will take a backup at the start of each hour.

### `TZ`

Olson database timezone name to be used when interpreting CRON syntax. Defaults to "UTC".

### `MONGO_URI`

Connection string for the MongoDB database. E.g. `mongodb://mongo:27017`

The connection string can contain options for authentication, disabling certificate validation, etc...

### `MONGO_CONFIG`

Path to config file to provide to `mongodump --config`. If your Mongo instance requires authentication, this is the recommended best-practice for specifying a password.

### `ARCHIVE_NAME`

By default this container dumps the database [to a directory](https://www.mongodb.com/docs/database-tools/mongodump/#dump-data-to-a-directory), specifically /backup.

This is because this plays nicely with incremental backups.

If ARCHIVE_NAME is specified, the container will instead produce a [single binary archive file](https://www.mongodb.com/docs/database-tools/mongodump/#dump-data-to-a-binary-archive-file) within the /backup directory. `ARCHIVE_NAME` specifies the name of this file.

To evaluate pros & cons of mongodump output formats, see the [mongodump documentation](https://www.mongodb.com/docs/manual/tutorial/backup-and-restore-tools/#std-label-considerations-output-format).

### `GZIP`

If specified as "true", the output file(s) will be compressed using gzip.

### `RETRIES`

There are [several operations](https://www.mongodb.com/docs/database-tools/mongodump/#std-option-mongodump.--oplog) which can cause a consistent backup to fail.

If this happens (or if any other failure occurs), the retries option can be used to automatically retry, waiting 1 minute between attempts.

The default value is 3.