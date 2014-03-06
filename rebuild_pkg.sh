#!/bin/bash
# vim:et sw=2 ts=2 ai:
# ref: http://archlinuxarm.org/developers/building-packages
#  makepkg -A --nocheck --skippgpcheck --skipinteg 
#  makepkg -AR --skippgpcheck  # repackage
#  yaourt -SAb <pkg>

set -o errexit ; set -o nounset

declare -A rundeps makedeps

dummys=(glibc)
st_pkgs=()
#fedora_pkgs=(libtirpc libtirpc-devel) # 0.1.7-18, AUR:0.2.2

rundeps=(
# glibc # stlinux 2.6.1-74, AUR 2.17-3
# gcc-libs # stlinux 4.2.4-76, AUR 4.7.2
[ncurses]="glibc"
[findutils]="glibc sh"
[readline]="glibc ncurses"
[bash]="readline glibc"
[zlib]="glibc"
[bzip2]="glibc"
[xz]="bash" # --nocheck , PKGBUILD comment off --enable-werror
[attr]="glibc"
[acl]="attr"
[gdbm]="glibc sh"
[db]="gcc-libs sh"
[cracklib]="glibc zlib"
[libgssglue]="glibc"
[libtirpc]="libgssglue"
[file]="glibc zlib"
[diffutils]="glibc sh"
[ed]=""
[patch]="ed"
[make]="glibc sh"
#[pambase] any arch
[m4]="glibc bash"
[flex]="glibc sh m4" # on h
# gettext # shpkg -S gettext
[sed]="acl sh"
[pcre]="gcc-libs" # --disable-jit # TODO: on k
[grep]="glibc pcre sh"
[fakeroot]="glibc filesystem sed util-linux sh"
[perl]="gdbm db coreutils glibc sh" 
[openssl]="perl" # dummy stlinux23-sh4-openssl stlinux23-sh4-openssl-dev
[gc]='gcc-libs' TODO:h
#[imlib2]="libtiff giflib bzip2 freetype2 libxext libpng libid3tag libjpeg-turbo"
#[w3m]="ncurses openssl gc imlib2" # stlinux w3m
#[docbook-xml]="
#[docbook-xsl]="
[pam]="glibc db cracklib libtirpc pambase" # TODO
[coreutils]="pam gmp libcap"
[expat]="glibc"
[libarchive]="zlib bzip2 xz acl openssl expat"
[pacman]="bash glibc libarchive curl gpgme pacman-mirrorlist archlinux-keyring"
[util-linux]="pam shadow coreutils glibc"
gtk2 qt pinentry
postgresql-libs libmysqlclient libldap krb5 libsasl
glib2 pkg-config e2fsprogs @t
libsasl e2fsprogs libldap(openldap)
libldap dirmngr-1.1.0-4-i686.pkg.tar.xz
libldap libusb? libusb-compat gnupg
gnupg gpgme-1.3.1-5-i686.pkg.tar.xz
pacman-mirrorlist-20130131-1-any.pkg.tar.xz
archlinux-keyring-20130127-1-any.pkg.tar.xz
pacman-4.0.3-5-sh4.pkg.tar.xz
)

makedeps=(
[pacman]="asciidoc"
[pam]="flex w3m docbook-xml docbook-xsl"
[readline]="findutils"
[attr]="gettext"
[libgssglue]="pkgconfig autoconf"
[libtirpc]="perl"
[sed]="gettext"
[grep]="textinfo"
[perl]="sed grep"
)

go() { # <pkg> [depends_pkgs]
  while if [ -n "${2:-}" ] ; do
    go 
  done
  if [ -r $1.pkg.tar.xz ] ; then
    echo "Info: skip $1"
    return 0
  fi
  echo "Info: building $1"
}

list_pkgs() {
  echo "List of built packages"
  ls *.pkg.tar.xz
}
list_pkgs
