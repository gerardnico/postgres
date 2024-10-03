#!/bin/bash


# /usr/local/lib/ is the standard location for locally installed, system-wide libraries.
source /usr/local/lib/bash/error.sh
source /usr/local/lib/bash/echo.sh





## A trap on ERR, if set, is executed before the shell exits.
# Because we show the $LINENO, we need to pass a command to the trap and not a function otherwise the line number would be not correct
trap 'error_handler "$LINENO" "${BASH_COMMAND}"' ERR

