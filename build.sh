#!/bin/bash

SCRIPT_DIR=$(dirname $(readlink -f $0))
LIB_GNURX_DIR=${SCRIPT_DIR}/libgnurx-2.5
MAX_JOBS=$(nproc 2>/dev/null || echo 2)

set -eu
export PS4='> '
set -x

mkdir dist/ local-file

cd ${LIB_GNURX_DIR}
make
#sudo cp regex.h /usr/x86_64-w64-mingw32/include/
#sudo cp libregex.a /usr/x86_64-w64-mingw32/lib/
#sudo cp libgnurx.dll.a /usr/x86_64-w64-mingw32/lib/
cp COPYING.LIB ../dist/COPYING.libgnurx
cp libgnurx-0.dll ../dist/
cd ../file/
autoreconf -f -i
./configure --prefix=${SCRIPT_DIR}/local-file --disable-silent-rules --enable-fsect-man5
make -j${MAX_JOBS}
make install
cp magic/magic.mgc ../dist/
export CFLAGS="-I${LIB_GNURX_DIR} -imacros windows-pipe.h -I${SCRIPT_DIR}/include"
export LDFLAGS="-L${LIB_GNURX_DIR}"
make clean
export LIBS="-lssp"
./configure --disable-silent-rules --enable-fsect-man5 --host=x86_64-w64-mingw32
# profile FILE_COMPILE since otherwise it would try to use "file.exe" even when cross-compiling
make -j${MAX_JOBS} FILE_COMPILE=${SCRIPT_DIR}/local-file/bin/file
cp src/.libs/libmagic-1.dll ../dist/
cp src/.libs/file.exe ../dist/
cp COPYING ../dist/COPYING.file
