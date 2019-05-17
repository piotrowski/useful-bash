#!/bin/bash
(
    DATABASE_USER='postgres'
    DATABSE_PASSWORD='Temporary'
    DATABSE_HOST='localhost'
    DATABASE_PORT='5432'

    BACKUP_DIR=${PWD}

    # add user@server:directory
    RSYNC_WITH=''
    SSH_PORT='22'


    ####

    export PGPASSWORD=${DATABSE_PASSWORD};
    export PGUSER=${DATABASE_USER};
    export PGHOST=${DATABSE_HOST};
    export PGPORT=${DATABASE_PORT};

    NOW="$(date +%y-%m-%d_%H-%M)"

    DB_BACKUP="$BACKUP_DIR/$NOW.dump"

    if pg_dumpall -f "$DB_BACKUP"
    then
        gzip -6 "$DB_BACKUP"
        echo "Database dumped"
    else
        exit 1
    fi


    rsync -a -e "ssh -p ${SSH_PORT}" "${DB_BACKUP}.gz" ${RSYNC_WITH} | exit 1

    echo "Files synchronised"
)