#!/bin/bash
# Checks if there's a composer.json, and if so, installs/runs composer.

set -euo pipefail

cd /opt/app

if [ -f /opt/app/composer.json ] ; then
    if [ ! -f composer.phar ] ; then
        curl -sS https://getcomposer.org/installer | php
    fi
    php composer.phar install
fi

mkdir -p var_original
test -L data || (cp -r data var_original && rm -rf data && ln -s /var/data .)
test -L uploads || (cp -r uploads var_original && rm -rf uploads && ln -s /var/uploads .)
