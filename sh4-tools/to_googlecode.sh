#!/bin/bash
set -e -u
go(){
  echo "** $@"
  "$@"
}

for f in *.pkg.tar.?z ; do
  if [ ! -r  "$f.ok" ] ; then
    go googlecode_upload.py -s $f -p sh4twbox -l Type-Package,ArchLinux $f
    sha1sum $f > $f.ok
  fi
done
for f in *.txz ; do
  if [ ! -r  "$f.ok" ] ; then
    go googlecode_upload.py -s $f -p sh4twbox -l Type-Package $f
    sha1sum $f > $f.ok
  fi
done
for f in sh4twbox.db archtest.db archany.db ; do
  if [ -r  $f ] && [ ! -r  $f.ok ] ; then
    go googlecode_upload.py -s $f -p sh4twbox -l Type-Index,MajorIndex,ArchLinux $f
    sha1sum $f > $f.ok
  fi
done
