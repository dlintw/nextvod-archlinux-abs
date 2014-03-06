#!/bin/bash
go() {
  echo $*
  $*
}
SSH="dbclient -i $HOME/.ssh/id_rsa"
$(dirname $0)/update_repo.sh $1
n=$2
go yaourt -Sy $2 --noconfirm -f
for h in h k hsu tsu c ; do
  go $SSH -t $h yaourt -Sfy --noconfirm $2
done
