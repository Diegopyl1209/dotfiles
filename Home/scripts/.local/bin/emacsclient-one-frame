#!/bin/bash

if [ $# -eq 0 ]; then
    emacsclient -c -n
    exit
fi

HAS_FRAME=$(emacsclient -e '(frame-parameter nil '\''display)')

if [[ "$HAS_FRAME" == "nil" ]]; then
    emacsclient -c -n "$@"
else
    emacsclient -n "$@"
fi
