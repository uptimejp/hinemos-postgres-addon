#!/bin/sh

MON_PGSQL_OPTS="-h localhost -p 5432 -U postgres -d postgres"

./mon_pgsql $MON_PGSQL_OPTS session
./mon_pgsql $MON_PGSQL_OPTS cache_hit
./mon_pgsql $MON_PGSQL_OPTS tuple_wrtn
./mon_pgsql $MON_PGSQL_OPTS tuple_read
./mon_pgsql $MON_PGSQL_OPTS blks_read
./mon_pgsql $MON_PGSQL_OPTS blks_wrtn
./mon_pgsql $MON_PGSQL_OPTS txn
./mon_pgsql $MON_PGSQL_OPTS xlog_wrtn
./mon_pgsql $MON_PGSQL_OPTS dbsize
./mon_pgsql $MON_PGSQL_OPTS locks
