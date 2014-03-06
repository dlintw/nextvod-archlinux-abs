#!/bin/sh
[ $# -ne 1 ] && echo "Usage:`basename $0` <pkg>"
[ $# -ne 1 ] && exit 1
type=svg
pactree -g $1 | dot -T$type -o $1.$type
chromium $1.$type
