#!/bin/bash

set -e

MARKDOWN_FILE=Pods/Pods-acknowledgements.markdown
if [ ! -f "$MARKDOWN_FILE" ]; then
    echo "Failed to locate $MARKDOWN_FILE. Have you run pod install?" >&2
    exit 1
fi

MARKDOWN=$(which markdown || true)
if [ -z "$MARKDOWN" ]; then
    MARKDOWN=/usr/local/bin/markdown
    if [ ! -x "$MARKDOWN" ]; then
        echo 'Unable to find markdown!' >&2
        echo 'Instal it with `brew install markdown`' >&2
        exit 1
    fi
fi

LICENSES_FILE="IgrejasRio/Resources/licenses.html"

cat >"$LICENSES_FILE" <<EOD
<!DOCTYPE html>
<body>
<head>
    <meta charset="UTF-8">
    <style type="text/css">
body {
    background: #ddd;
    font-family: "Helvetica Neue", "Helvetica";
    font-size: 90%;
}

h1 {
    font-size: 120%;
}

h2 {
    font-size: 110%;
}
    </style>
</head>
EOD

$MARKDOWN "$MARKDOWN_FILE" >>"$LICENSES_FILE"

cat >>"$LICENSES_FILE" <<EOD
</body>
</html>
EOD
