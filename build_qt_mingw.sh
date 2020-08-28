#!/usr/bin/env bash 
set -e

######## NOTICE ########
Please run this from a clean MSYS2 build.
########################

pacman -Syu --noconfirm perl python make zip unzip

wget https://github.com/mstorsjo/llvm-mingw/releases/download/20200325/llvm-mingw-20200325-x86_64.zip

mkdir -p /c/qt/
mkdir -p /c/qt/llvm-qt
unzip llvm-mingw-20200325-x86_64.zip -d /c/qt/
export PATH=/c/qt/llvm-mingw:$PATH

CORE=$(python -c "import multiprocessing; print(multiprocessing.cpu_count())")

./configure -platform win32-clang-g++ \
-opensource -confirmlicence \
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
cd /c/
zip -r cuhksz-qt.zip qt
