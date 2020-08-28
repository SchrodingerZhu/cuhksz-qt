#!/usr/bin/env bash 
set -e

LLVM_VERSION=20200325
QT_MAJOR_VER=5.15
QT_MINOR_VER=0

######## NOTICE ########
Please run this from a clean MSYS2 build.
########################

### Prepare essential build tools
pacman -Syu --noconfirm perl python make zip unzip wget

### Download source code and toolchains
wget https://github.com/mstorsjo/llvm-mingw/releases/download/$LLVM_VERSION/llvm-mingw-$LLVM_VERSION-x86_64.zip
wget http://qt.mirror.constant.com/official_releases/qt/$QT_MAJOR_VER/$QT_MAJOR_VER.$QT_MINOR_VER/single/qt-everywhere-src-$QT_MAJOR_VER.$QT_MINOR_VER.zip
unzip qt-everywhere-src-$QT_MAJOR_VER.$QT_MINOR_VER.zip
cd qt-everywhere-src-$QT_MAJOR_VER.$QT_MINOR_VER

### Prepare building environment
mkdir -p /c/qt/
mkdir -p /c/qt/llvm-qt
export PATH=/c/qt/llvm-mingw:$PATH
unzip llvm-mingw-$LLVM_VERSION-x86_64.zip -d /c/qt/
CORE=$(python -c "import multiprocessing; print(multiprocessing.cpu_count())")

### Build
./configure -platform win32-clang-g++ \
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
