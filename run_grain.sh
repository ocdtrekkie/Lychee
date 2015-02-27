#!/bin/bash

set -e

CURRENT_VERSION="0"

cp -r /etc/service /tmp
test -d /var/log || cp -r /var_original/log /var
test -d /var/lib || cp -r /var_original/lib /var
test -d /var/run || cp -r /var_original/run /var
test -e /var/lock || ln -s /var/run/lock /var/lock
test -d /var/uploads || cp -r /var_original/uploads /var
test -d /var/data || (cp -r /var_original/data /var && echo $CURRENT_VERSION > /var/VERSION)

[[ "$(cat /var/VERSION)" == "${CURRENT_VERSION}" ]] || (cd /opt/app && echo "Upgrading Database...." && ./bin/update.sh && echo $CURRENT_VERSION > /var/VERSION)


mkdir -p /var/mail
touch /var/mail/dovecot-uidlist /var/mail/dovecot-uidvalidity /var/mail/dovecot.index.log
mkdir -p /var/log/roundcube/ /var/tmp
rm -rf /var/run/dovecot

exec /sbin/my_init
