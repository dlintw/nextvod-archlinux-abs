go(){ 
  echo $*
  $*
}

if [ -z "$1" ] ; then
  echo "Usage 1 :`basename $0` update -- update package versions"
  echo "Usage 2 :`basename $0` <package_name> ... -- get package(s) source"
elif [ "$1" = update ] ; then
  go yaourt -Sy --config /etc/pacman.src.conf
else
  go yaourt --config /etc/pacman.src.conf -G $*
fi
