#!/usr/bin/env bash

BINARY="python"
PARAMS="-m homeassistant --config /config"

######################################################

CMD=$1

if [[ -z "${CONFIG_LOG_TARGET}" ]]; then
  LOG_FILE="/dev/null"
else
  LOG_FILE="${CONFIG_LOG_TARGET}"
fi

case $CMD in

describe)
    echo "Sleep $PARAMS"
    ;;

## exit 0 = is not running
## exit 1 = is running
is-running)
    if pgrep -f "$BINARY $PARAMS" >/dev/null 2>&1 ; then
        exit 1
    fi
    exit 0
    ;;

start)
    echo "Starting... $BINARY $PARAMS" >> "$LOG_FILE"
    if pgrep -f "socat" >/dev/null 2>&1 ; then
        # socat is running
        cd /usr/src/homeassistant
        $BINARY $PARAMS 2>$LOG_FILE >$LOG_FILE &
        exit 0
    else
        # socat is not running
        echo "##### Socat is not running, skipping start of home assistant"
        exit 1
    fi
    ;;

start-fail)
    echo "Start failed! $BINARY $PARAMS"
    ;;

stop)
    echo "Stopping... $BINARY $PARAMS"
    cd /usr/src/homeassistant
    kill -9 $(pgrep -f "$BINARY $PARAMS")
    ;;

esac
