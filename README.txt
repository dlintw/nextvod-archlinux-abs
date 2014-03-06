# vim:et sw=2 ts=2 ai:
# ref: https://wiki.archlinux.org/index.php/Pacman_Tips

TODO
====

gnutls, groff & glib2 # use sh4twbox previous build version
distcc
base-devel
nfs-utils,glib2,python2
uushare,ffmpeg
groff,ocaml

Unsolved Build Problem in STLinux 2.4
=====================================
glibc: nptl/pthread_sping_lock.o {standard input}:2203: Error: tas.b use
pack from STLinux 2.4: sh4-binutils sh4-gcc sh4-glibc sh4-linux-api-headers
sh4-mpfr: require asm support
systemd: kernel require support cgroup function (2.6.36 is required)
llvm: binutils lack /usr/include/plugin-api.h
boost.openmpi.clang.mesa.llvm.ocaml: not implement in asmrun/sh4.S
lvm2 with thin-provisioning-tools: boost
js: no sh4 porting
cups: js can not build
xvidcore: nasm require Intel CPU
groff: js
libxmu:libx11 internal compiler bug
libgu:llvm
freeglut:mesa
glu: llvm
jasper: glu
mc: slang: internal compiler bug


Arch Package for NextVOD Naming Rules
=====================================
1. If PKGBUILD is totally different than original's arch, add prefix sh4-. And use *conflicts* and *provides* keyword.
  eg. sh4-glibc

2. If PKGBUILD could use yaourt -AsL build, don't check it in git repository.

3. If PKGBUILD is a little different than original Arch's, added a
  sub-replease version. eg. Arch is 1.2-3  then we use 1.2-3.1
  arch=('i686' 'x86_64' 'sh4')
  eg. e2fsprogs 1.42.8-2.1

4. For old PKGBUILD.0 it should rename package name to sh4-xxx.

5. For old PKGBUILD.1 or PKGBUILD.2 it should renamed to PKGBUILD.  If that means stage, then use sh4-xxx-stage1.

Arch Package Build Tools
========================
1. Setup up common environment variables for sh4-tools::

  cd sh4-tools
  cp env.tmpl env
  vi env
  # on your local web site
  mkdir www/mirror
  cd www/mirror
  mkdir archany archtest src
  # mapping your home directory www to the web site repository

2. Build a full dependency (eg. pacman)::

  cd sh4-tools
  ./gen_base_makelist # generate base.makelist and base-devel.makelist
  ./build_arch_by_list pacman # it will generate pacman.makelist
  vi pacman.makelist # if you want to mark off some packages.

3. When error occurs, try build one package manually::

  cd xxx
  ../sh4-tools/get_local_src # get source local mirror/src
  makepkg -AsL
  ../sh4-tools/upd_arch_repo xxx.pkg.tar.gz
  yaourt -U xxx.pkg.tar.gz

4. We use pkg.tar.gz format instead of .xz. Because it will save
  compressing time. It will be repack to .xz on PC for release.

CA key problem Solution
=======================
#https://wiki.archlinux.org/index.php/Pacman-key
sudo pacman-key --init
sudo pacman-key --populate archlinux
sudo pacman-key --refresh-keys
#https://wiki.archlinux.org/index.php/Makepkg
gpg --list-keys
echo 'keyring /etc/pacman.d/gnupg/pubring.gpg' >> ~/.gnupg/gpg.conf
#https://wiki.archlinux.org/index.php/GnuPG
gpg --gen-key

Patch Tips
==========

Append Line
-----------
sed '1 a\
> mpfr' -i ~/libmpc

Build Chroot Root File System
=============================

* install arch-install-scripts
* mount the target device on /mnt directory
  *  mkdir -p /mnt/dev/pts /mnt/shm
* use pacstrap to install comment out the track_mount.*devtmps line of pacstrap
* ./pacstrap -C archsh4.conf /mnt base openssh nettle yaourt localepurge
* mychroot /mnt
  * vi /etc/localepurge.conf # append zh_TW zh_TW.UTF-8 lines.
  * localepurge
  * pacman -Sccc
  * passwd # change password

Problems
========

  Q: df can not work
  A: cat /proc/mounts | grep -v rootfs > /etc/mtab

  Q: telnet failed
  A: should use xinetd
    k can not login by telnet: telnetd is disabled by inetutils
    ln -sf ../bin/busybox /sbin/telnetd

  Q: Err: tab.s ...
  A: maybe we should enable some gcc 4.8 flags http://gcc.gnu.org/gcc-4.8/changes.html#sh

methods:
  pacman -Slq -g base -g base-devel |sort -u # list all required packages
  pactree <pkgname> -- list which package required to install
  pactree -r <pkgname> -- show which packages should rebuild after pkgname

gcc
---

/home/dlin/prj/abs/gcc/src/gcc-build/./gcc/xgcc: symbol lookup error: /home/dlin/prj/abs/gcc/src/gcc-build/sh4-unknown-linux-gnu/libstdc++-v3/src/.libs/libstdc++.so.6: undefined symbol: _ZNSt8messagesIcE2idE
make[5]: *** [alloc.lo] Error 1
make[5]: Leaving directory `/home/dlin/prj/abs/gcc/src/gcc-build/sh4-unknown-linux-gnu/libgomp'
make[4]: *** [all-recursive] Error 1
make[4]: Leaving directory `/home/dlin/prj/abs/gcc/src/gcc-build/sh4-unknown-linux-gnu/libgomp'
make[3]: *** [all] Error 2
make[3]: Leaving directory `/home/dlin/prj/abs/gcc/src/gcc-build/sh4-unknown-linux-gnu/libgomp'
make[2]: *** [all-stage1-target-libgomp] Error 2
make[2]: Leaving directory `/home/dlin/prj/abs/gcc/src/gcc-build'
make[1]: *** [stage1-bubble] Error 2
make[1]: Leaving directory `/home/dlin/prj/abs/gcc/src/gcc-build'
make: *** [all] Error 2

glibc
-----

Doing
=====
base:
pacman:
fail: kernel systemd libudev device-mapper(lvm2) cryptsetup
ignore: jfsutils xfsprogs reiserfsprogs pciutils pcmciautils systemd-sysvcompat
dummy:
  busybox: vi cron sed which dhcpcd

  iptables: stlinux23-sh4-iptables stlinux23-sh4-iptables-dev 1.4.2-10.sh4
    In file included from libxt_connbytes.c:4:
    ../include/linux/netfilter/xt_connbytes.h:20: error: expected specifier-qualifier-list before '__aligned_u64'
    libxt_connbytes.c: In function 'connbytes_parse':
    libxt_connbytes.c:39: error: 'struct <anonymous>' has no member named 'from'
    require newer linux kernel headers

  tk tcl: stlinux23-sh4-tcl 8.5.8-3 stlinux23-sh4-tcl-dev # build failed
    /home/dlin/abs/local/tcl/src/tcl8.6.0/generic/tclStrToD.c: In function 'TclParseNumber':
    /home/dlin/abs/local/tcl/src/tcl8.6.0/generic/tclStrToD.c:1403: internal compiler error: Segmentation fault
    Please submit a full bug report,
    with preprocessed source if appropriate.
    See <URL:https://bugzilla.stlinux.com> for instructions.
    make: *** [tclStrToD.o] Error 1

  pam: pam pam-devel 1.0.1-4.fc9.sh4
    In file included from pam_namespace.c:37:
    pam_namespace.h:68:29: error: selinux/selinux.h: No such file or directory
    pam_namespace.h:69:38: error: selinux/get_context_list.h: No such file or directory

  keyutils: stlinux23-sh4-keyutils 1.2-3.fc9.sh4
    key.dns_resolver.o: In function `main':
    key.dns_resolver.c:(.text+0xfc0): undefined reference to `__ns_initparse'
    key.dns_resolver.c:(.text+0xfd0): undefined reference to `__ns_parserr'
    key.dns_resolver.c:(.text+0x1158): undefined reference to `__ns_name_uncompress'


dbus: configure: error: Explicitly requested systemd support, but systemd not found

kmod
----

checking pkg-config is at least version 0.9.0... /usr/bin/pkg-config: error whil
e loading shared libraries: libpcre.so.1: cannot open shared object file: No suc
h file or directory
no
checking for __xstat... yes
checking for struct stat.st_mtim... yes
configure: Xz support not requested
checking for zlib... no
configure: error: in `/home/dlin/abs/local/kmod/src/kmod-12':
configure: error: The pkg-config script could not be found or is too old.  Make
sure it
is in your PATH or set the PKG_CONFIG environment variable to the full
path to pkg-config.

Alternatively, you may set the environment variables zlib_CFLAGS
and zlib_LIBS to avoid the need to call pkg-config.
See the pkg-config man page for more details.

To get pkg-config, see <http://pkg-config.freedesktop.org/>.
See `config.log' for more details
==> ERROR: A failure occurred in build().
    Aborting...

lvm2
----
  -> Extracting LVM2.2.02.98.tgz with bsdtar
  ==> Removing existing pkg/ directory...
  ==> Starting build()...
  checking build system type... sh4-unknown-linux-gnu
  checking host system type... sh4-unknown-linux-gnu
  checking target system type... sh4-unknown-linux-gnu
  checking for a sed that does not truncate output... /usr/bin/sed
  checking for gawk... gawk
  checking for gcc... gcc
  checking whether the C compiler works... yes
  checking for C compiler default output file name... a.out
  checking for suffix of executables...
  checking whether we are cross compiling... no
  checking for suffix of object files... configure: error: in `/home/dlin/abs/local/lvm2/src/LVM2.2.02.98':
  configure: error: cannot compute suffix of object files: cannot compile
  See `config.log' for more details
  ==> ERROR: A failure occurred in build().
      Aborting...

rarian
------
Making all in util
make[2]: Entering directory `/home/dlin/abs/local/rarian/src/rarian-0.8.1/util'
gcc -DHAVE_CONFIG_H -I. -I.. -I./../librarian    -O2 -pipe -MT rarian-example.o -MD -MP -MF .deps/rarian-example.Tpo -c -o rarian-example.o rarian-example.c
mv -f .deps/rarian-example.Tpo .deps/rarian-example.Po
/bin/sh ../libtool --tag=CC   --mode=link gcc  -O2 -pipe   -o rarian-example rarian-example.o ../librarian/librarian.la
mkdir .libs
gcc -O2 -pipe -o .libs/rarian-example rarian-example.o  ../librarian/.libs/librarian.so
/usr/bin/ld: .libs/rarian-example: hidden symbol `__sdivsi3_i4i' in /usr/lib/gcc/sh4-linux/4.2.4/libgcc.a(_div_table.o) is referenced by DSO
/usr/bin/ld: final link failed: Nonrepresentable section on output
collect2: ld returned 1 exit status
make[2]: *** [rarian-example] Error 1
make[2]: Leaving directory `/home/dlin/abs/local/rarian/src/rarian-0.8.1/util'
make[1]: *** [all-recursive] Error 1
make[1]: Leaving directory `/home/dlin/abs/local/rarian/src/rarian-0.8.1'
make: *** [all] Error 2
==> ERROR: A failure occurred in build().
    Aborting...

js
--
from /home/dlin/prj/abs/js/src/mozjs17.0.0/js/src/jsreflect.cpp:23:
./jscntxtinlines.h: In member function 'JSObject* js::NewObjectCache::newObjectFromHit(JSContext*, js::NewObjectCache::EntryIndex)':
./jscntxtinlines.h:110:84: warning: cast from 'char (*)[144]' to 'JSObject*' increases required alignment of target type [-Wcast-align]
In file included from ./jsobjinlines.h:45:0,
                 from ./jsscopeinlines.h:28,
                 from ./jsscriptinlines.h:21,
                 from /home/dlin/prj/abs/js/src/mozjs17.0.0/js/src/vm/Stack-inl.h:17,
                 from /home/dlin/prj/abs/js/src/mozjs17.0.0/js/src/jsinferinlines.h:18,
                 from /home/dlin/prj/abs/js/src/mozjs17.0.0/js/src/jsreflect.cpp:23:
./jsinferinlines.h: In member function 'JSCompartment* js::types::TypeCompartment::compartment()':
./jsinferinlines.h:917:75: warning: cast from 'char*' to 'JSCompartment*' increases required alignment of target type [-Wcast-align]
./jsinferinlines.h: In member function 'js::types::TypeObject* js::types::TypeSet::getTypeObject(unsigned int)':
./jsinferinlines.h:1329:60: warning: cast from 'js::types::TypeObjectKey*' to 'js::types::TypeObject*' increases required alignment of target type [-Wcast-align]
./jsinferinlines.h: In instantiation of 'U** js::types::HashSetInsert(js::LifoAlloc&, U**&, unsigned int&, T) [with T = js::types::TypeObjectKey*; U = js::types::TypeObjectKey; KEY = js::types::TypeObjectKey]':
./jsinferinlines.h:1228:76:   required from here
./jsinferinlines.h:1077:13: warning: cast from 'js::types::TypeObjectKey*' to 'js::types::TypeObjectKey**' increases required alignment of target type [-Wcast-align]
{standard input}: Assembler messages:
{standard input}:33383: Error: invalid operands (*UND* and .text._ZN2js13ASTSerializer3xmlEPNS_8frontend9ParseNodeEPN2JS5ValueE sections) for `-'
{standard input}:33393: Error: invalid operands (*UND* and .text._ZN2js13ASTSerializer3xmlEPNS_8frontend9ParseNodeEPN2JS5ValueE sections) for `-'
{standard input}:33766: Error: invalid operands (*UND* and .text._ZN2js13ASTSerializer3xmlEPNS_8frontend9ParseNodeEPN2JS5ValueE sections) for `-'
make[1]: *** [jsreflect.o] Error 1
make[1]: Leaving directory `/home/dlin/prj/abs/js/src/mozjs17.0.0/js/src'
