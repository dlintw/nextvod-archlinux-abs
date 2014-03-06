#!/bin/bash
# vim:et sw=2 ts=2 ai:
set -o errexit ; set -o nounset
echo "checking files in /bin /sbin"
for f in /bin/* /sbin/* ; do
  name=$(basename $f)
  if [ -L $f -a $(basename $(realpath $f)) = busybox ] ; then
    if [ -x /usr/bin/$name -o -x /usr/sbin/$name ] ; then
      echo "remove duplicate busybox binary: $f"
      busybox rm $f
    fi
  fi
done
echo "DONE"
