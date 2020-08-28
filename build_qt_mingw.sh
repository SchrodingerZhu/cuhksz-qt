#!/usr/bin/env bash 
# Please install Visual C++ Redistributale MSVC2015 First

set -e

LLVM_VERSION=20200325
QT_MAJOR_VER=5.15
QT_MINOR_VER=0
OPENSSL_VER=1.1.1g
ICU_MAJOR_VER=67
ICU_MINOR_VER=1

######## NOTICE ########
Please run this from a clean MSYS2 build.
########################

### Prepare essential build tools
### Fix previous error: Syu will terminate MSYS terminal
pacman -Sy --noconfirm perl python make zip unzip wget

### Prepare building environment
mkdir -p /c/qt/
mkdir -p /c/qt/llvm-qt
export PATH=/c/qt/llvm-mingw/bin/:$PATH
CORE=$(python -c "import multiprocessing; print(multiprocessing.cpu_count())")

### Download source code and toolchains
wget https://github.com/unicode-org/icu/releases/download/release-$ICU_MAJOR_VER-$ICU_MINOR_VER/icu4c-$ICU_MAJOR_VER_$ICU_MINOR_VER-Win64-MSVC2017.zip
wget https://www.openssl.org/source/openssl-$OPENSSL_VER.tar.gz
wget https://github.com/mstorsjo/llvm-mingw/releases/download/$LLVM_VERSION/llvm-mingw-$LLVM_VERSION-x86_64.zip
wget http://qt.mirror.constant.com/official_releases/qt/$QT_MAJOR_VER/$QT_MAJOR_VER.$QT_MINOR_VER/single/qt-everywhere-src-$QT_MAJOR_VER.$QT_MINOR_VER.zip
unzip qt-everywhere-src-$QT_MAJOR_VER.$QT_MINOR_VER.zip
unzip llvm-mingw-$LLVM_VERSION-x86_64.zip -d /c/qt/
unzip icu4c-$ICU_MAJOR_VER_$ICU_MINOR_VER-Win64-MSVC2017.zip
tar xvzf openssl-$OPENSSL_VER.tar.gz


## Install ICU
cp -r bin64/* /c/qt/llvm-mingw/bin
cp -r lib64/* /c/qt/llvm-mingw/lib
cp -r include/* /c/qt/llvm-mingw/include

## Build and install Openssl
cd openssl-$OPENSSL_VER
./Configure shared mingw64 --prefix=/c/qt/llvm-mingw/ --openssldir=/c/qt/llvm-mingw/
make depend
make -j$CORE -s
make install
cd ..

### Build Qt
cd qt-everywhere-src-$QT_MAJOR_VER.$QT_MINOR_VER
./configure -platform win32-clang-g++ \
-icu -openssl \
-opensource -confirm-license \
-opengl desktop -skip qtx11extras -skip qtwayland \
-skip qtactiveqt -skip qtandroidextras -skip qtserialbus \
-skip qtdeclarative -skip qtdatavis3d -skip qtcharts \
-skip qtnetworkauth -skip qtmacextras -skip qtvirtualkeyboard \
-skip qt3d -skip qtsensors -skip qtwebengine -skip qtspeech \
-skip qttranslations -skip qtgamepad -skip qtdoc \
-skip qtlottie -skip qtserialport -skip qtquick3d \
-skip qtremoteobjects -skip qtquickcontrols \
-skip qtquickcontrols2 -skip qtquicktimeline \
-skip qtconnectivity -no-compile-examples -release -prefix /c/qt/llvm-qt

make -j$CORE -s
make install -j$CORE -s

### Zip artifects
cd /c/
zip -r cuhksz-qt.zip qt
