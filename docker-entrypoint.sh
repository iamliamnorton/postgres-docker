#!/bin/sh

chown -R postgres "$PGDATA"

if [ -z "$(ls -A "$PGDATA")" ]; then
  gosu postgres initdb
  sed -ri "s/^#(listen_addresses\s*=\s*)\S+/\1'*'/" "$PGDATA"/postgresql.conf

  : ${POSTGRES_USER:="postgres"}
  : ${POSTGRES_DB:=$POSTGRES_USER}

  if [ "$POSTGRES_PASSWORD" ]; then
    pass="PASSWORD '$POSTGRES_PASSWORD'"
    authMethod=md5
  else
    pass="PASSWORD 'password'"
    authMethod=trust
  fi
  echo


  if [ "$POSTGRES_DB" != 'postgres' ]; then
    createSql="CREATE DATABASE $POSTGRES_DB;"
    echo $createSql | gosu postgres postgres --single -jE
    echo
  fi

  if [ "$POSTGRES_USER" != 'postgres' ]; then
    op=CREATE
  else
    op=ALTER
  fi

  userSql="$op USER $POSTGRES_USER WITH SUPERUSER $pass;"
  echo $userSql | gosu postgres postgres --single -jE
  echo

  { echo; echo "host all all 0.0.0.0/0 $authMethod"; } >> "$PGDATA"/pg_hba.conf
fi

exec gosu postgres "$@"