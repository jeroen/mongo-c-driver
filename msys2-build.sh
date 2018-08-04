#/bin/sh
cd "$(dirname "$0")"
if [ -z "${MINGW_PREFIX}" ]; then
MINGW_PREFIX="/${MINGW_INSTALLS}"
fi

# reduce time required to install packages by disabling pacman's disk space checking
sed -i 's/^CheckSpace/#CheckSpace/g' /etc/pacman.conf
pacman --noconfirm -Syu
pacman --noconfirm --needed -S mingw-w64-{i686,x86_64}-{gcc,cmake,extra-cmake-modules,cyrus-sasl} make tar

mkdir cmake-build && cd cmake-build
export CFLAGS="-Wall"
export PATH="${MINGW_PREFIX}/bin:${PATH}"
${MINGW_PREFIX}/bin/cmake \
	-G "MSYS Makefiles" \
	-DCMAKE_BUILD_TYPE=Release \
	-DCMAKE_INSTALL_PREFIX=${MINGW_PREFIX} \
	-DENABLE_AUTOMATIC_INIT_AND_CLEANUP=OFF \
	..

make
make install

# Run some tests
./src/libmongoc/example-client
