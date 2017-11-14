#!/bin/sh

which pip 2>/dev/null > /dev/null \
    && echo pip \
    && (pip freeze --disable-pip-version-check | sort);

which dpkg 2>/dev/null > /dev/null \
    && echo dpkg \
    && (dpkg-query -W -f='${binary:Package}-${Version}.${Architecture}\n' | sort -k 2);

which rpm 2>/dev/null > /dev/null \
    && echo rpm \
    && (rpm -qa | sort)
