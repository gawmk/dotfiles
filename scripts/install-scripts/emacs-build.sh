#!/bin/bash

read -p "Which version of emacs would you like to build?: " VERSION

BUILDDIR="$HOME/source/emacs-build"
WGET_FILE="emacs-"$VERSION".tar.gz"
WGET_FILE_SIG="emacs-"$VERSION".tar.gz.sig"


if [ -d $BUILDDIR ]; then
    cd $BUILDDIR && sudo make uninstall && rm -rf $BUILDDIR
    echo "Previous install cleaned and directory removed"
fi

mkdir $BUILDDIR && cd $BUILDDIR
wget -c https://ftpmirror.gnu.org/emacs/$WGET_FILE
wget -c https://ftpmirror.gnu.org/emacs/$WGET_FILE_SIG


gpg --keyserver keyserver.ubuntu.com --recv-keys \
    17E90D521672C04631B1183EE78DAE0F3115E06B
gpg --verify $WGET_FILE_SIG


gpg --verify $WGET_FILE_SIG
read -p "Is the signature correct? [y/n] " sig
if [ "$sig" != "y" ]; then
    rm -rf $BUILDDIR
    exit 1
fi

tar xvfz $WGET_FILE && cd emacs-$VERSION

sudo apt install build-dep emacs
sudo apt install build-essential
./configure --with-native-compilation\
            --with-tree-sitter\
			--with-gif\
			--with-png\
			--with-jpeg\
			--with-rsvg\
			--with-tiff\
			--with-imagemagick\
			--with-mailutils\
			--with-modules\

make clean
make -j8
./src/emacs --version

read -p "Is everything in order?: [y/n] " resp
if [ "$resp" != "y" ]; then
    rm -rf $BUILDDIR
    echo "builddir removed"
    exit 1
fi

sudo make install 
 

