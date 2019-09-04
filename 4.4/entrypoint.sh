#!/bin/bash
set -eux

OPTS=$(getopt --long initialize-database,root-password:,rt-server:,port:, -n 'parse-options' -- "$@")

eval set -- "$OPTS"

INIT_DB=disable
ROOT_PW=password
RT_SERVER=""
PORT=80

while true; do
  case "$1" in
    --initialize-database ) INIT_DB=enable; shift ;;
    --root-password )       ROOT_PW="$2"; shift ;;
    --rt-server )           RT_SERVER="$2"; shift ;;
    --port )                PORT="$2"; shift; shift ;;
    -- ) shift; break ;;
    * ) break ;;
  esac
done

if [ "${RT_SERVER:-nil}" = "enable" ]
then
    set -- $RT_HOME/sbin/rt-server
    ./sbin/rt-server ${SERVER} ${PORT}
fi

if [ "${APACHE:-nil}" = "enable" ]
then
    echo "TODO: start apache"


#if [ "$1" = 'postgres' ]; then
#    chown -R postgres "$PGDATA"
#
#    if [ -z "$(ls -A "$PGDATA")" ]; then
#        gosu postgres initdb
#    fi
#
#    exec gosu postgres "$@"
#fi
#
#exec "$@"
