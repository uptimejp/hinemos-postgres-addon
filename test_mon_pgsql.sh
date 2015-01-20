#!/bin/sh

_initdb()
{
    initdb -D /tmp/pgsql/data --no-locale -E UTF-8
}

_pgctl_start()
{
    pg_ctl -w -D /tmp/pgsql/data start
}

_pgctl_stop()
{
    pg_ctl -w -D /tmp/pgsql/data stop
}

_cleanup()
{
    rm -rf /tmp/pgsql/data
}

_runtest()
{
    monlog=$1
    outlog=$2

    cat /dev/null > output/$monlog
    cat /dev/null > output/$outlog

    MON_PGSQL_OPTS="$MON_PGSQL_OPTS -l output/$monlog"
    export MON_PGSQL_OPTS

    ./mon_pgsql $MON_PGSQL_OPTS session | tee -a output/$outlog
    ./mon_pgsql $MON_PGSQL_OPTS cache_hit | tee -a output/$outlog
    ./mon_pgsql $MON_PGSQL_OPTS tuple_wrtn | tee -a output/$outlog
    ./mon_pgsql $MON_PGSQL_OPTS tuple_read | tee -a output/$outlog
    ./mon_pgsql $MON_PGSQL_OPTS blks_read | tee -a output/$outlog
    ./mon_pgsql $MON_PGSQL_OPTS blks_wrtn | tee -a output/$outlog
    ./mon_pgsql $MON_PGSQL_OPTS txn | tee -a output/$outlog
    ./mon_pgsql $MON_PGSQL_OPTS xlog_wrtn | tee -a output/$outlog
    ./mon_pgsql $MON_PGSQL_OPTS dbsize | tee -a output/$outlog
    ./mon_pgsql $MON_PGSQL_OPTS locks | tee -a output/$outlog
}

_testsuite()
{
    PGHOME=$1
    export PGHOME
    PATH=${PGHOME}/bin:$PATH
    export PATH

    echo PGHOME=$PGHOME

    rm -rf /var/tmp/mon_pgsql.cache
    _initdb
    _pgctl_start
    
    _runtest $2 $3

    diff -rc expected/$3 output/$3 | tee -a test_mon_pgsql.diff
    
    _pgctl_stop
    _cleanup
}

#MON_PGSQL_OPTS="-h localhost -p 5432 -U postgres -d postgres"
#MON_PGSQL_OPTS="-l mon_pgsql.log -v -h localhost -p 5432 -U $USER -d postgres"
MON_PGSQL_OPTS="-v -U $USER -d postgres"
export MON_PGSQL_OPTS

rm test_mon_pgsql.diff
rm *.log

_testsuite /usr/pgsql-9.0 mon_pgsql90.log pgsql90.log
_testsuite /usr/pgsql-9.1 mon_pgsql91.log pgsql91.log
_testsuite /usr/pgsql-9.2 mon_pgsql92.log pgsql92.log
_testsuite /usr/pgsql-9.3 mon_pgsql93.log pgsql93.log
_testsuite /usr/pgsql-9.4 mon_pgsql94.log pgsql94.log
