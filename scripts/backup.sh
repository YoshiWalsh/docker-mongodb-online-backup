#!/bin/bash

MONGODUMP_COMMAND=('mongodump' '--oplog')

if [[ -n $MONGO_URI ]]; then
    MONGODUMP_COMMAND+=("--uri=\"${MONGO_URI}\"")
fi

if [[ -n $MONGO_CONFIG ]]; then
    MONGODUMP_COMMAND+=("--config=\"${MONGO_CONFIG}\"")
fi

if [[ -n $GZIP ]]; then
    MONGODUMP_COMMAND+=("--gzip")
fi

if [[ -n $ARCHIVE_NAME ]]; then
    MONGODUMP_COMMAND+=("--archive=\"${ARCHIVE_NAME}\"")
else
    MONGODUMP_COMMAND+=("--out=\"/backup\"")
fi


if ! (r=${RETRIES:-3}; while ! "${MONGODUMP_COMMAND[@]}" ; do
        ((--r))||exit;
        echo "Backup failed, will retry in 60s.";
        sleep 60;
        done) ; then
    echo "Backup failed ${RETRIES:-3} time(s), giving up for now."
else
    echo "Backup successful!"
fi
