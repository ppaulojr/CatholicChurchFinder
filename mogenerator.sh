#!/bin/bash

set -e

MOGENERATOR=$(which mogeneator || true)
if [ -z "$MOGENERATOR" ]; then
    MOGENERATOR=/usr/local/bin/mogenerator
    if [ ! -x "$MOGENERATOR" ]; then
        echo 'Unable to find mogenerator!' >&2
        echo 'Instal it with `brew install mogenerator`' >&2
        exit 1
    fi
fi

set -x

"$MOGENERATOR" \
    -m IgrejasRio/Model.xcdatamodeld/Model.xcdatamodel \
    --machine-dir IgrejasRio/mogenerator \
    --human-dir IgrejasRio \
    --template-var arc=true
