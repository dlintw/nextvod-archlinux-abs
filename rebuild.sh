#!/bin/bash
# vim:set et sw=2 ts=2 ai:

# skip busybox covered packages NOTE: keep spaces between word
skippkgs=" cronie dhcpcd jfsutils linux lvm2 mdadm nano pciutils pcmciautils ppp reiserfsprogs xfsprogs vi device-mapper cryptsetup "

set -o errexit ; set -o nounset

go() {
  echo "$*"
  $*
}

if [ ! -r list.1 ] ; then
  pacman -Sg base | awk '{print $2}' > list.1
fi
for name in $(cat list.1) ; do
  rc=0
  # check is installed
  pacman -Q $name >/dev/null 2>&1 || rc=1
  if [ $rc = 1 ] && [[ "$skippkgs" != *" $name "* ]]; then
    # check architecture
    rc=0
    pacman -Sp $name >/dev/null 2>/dev/null || rc=1
    if [ $rc = 1 ] ; then
      read -p "$name: build? (Y/n)?" a
      if [ "$a" = "n" ] ; then
        continue
      fi
      cd ~/abs
      go yaourt -G $name
      cd $name
      go makepkg -A --nocheck --skippgpcheck --skipinteg
    fi
    read -p "$name: install/no/force? (Y/n/f)" a
    [ "$a" = "n" ] && continue
    rc=0
    if [ "$a" = "f" ] ; then
      go yaourt -S $name --force --noconfirm
    else
      go yaourt -S $name || rc=1
    fi
  fi
done
