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
