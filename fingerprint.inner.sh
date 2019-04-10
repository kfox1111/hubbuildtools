#!/bin/sh

[ -x /usr/bin/pip ] \
    && echo pip \
    && (pip freeze --disable-pip-version-check | sort);

[ -x /usr/bin/dpkg-query ] \
    && echo dpkg \
    && (dpkg-query -W -f='${binary:Package}-${Version}.${Architecture}\n' | sort -k 2);

[ -x /usr/bin/rpm ] \
    && echo rpm \
    && (rpm -qa | sort)

[ -x /sbin/apk -a "x$FINGERPRINT_SKIP_ALPINE" = "x" ] \
    && echo apk \
    && (apk info -v | grep -v '^WARNING: ' | sort )

if [ -d /data ]; then
    files=$(ls /data/*.rpm 2> /dev/null | wc -l)
    if [ $files -gt 0 ]; then
        echo rpm-repo
        ls /data/*.rpm | sed 's@^/data/@@; s@\.rpm$@@' | sort
    fi
fi
