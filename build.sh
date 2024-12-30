#!/bin/bash

######################################
## Build script for libimobiledevice #
##          by @Marcelektro          #
######################################


# exit on error
set -e


# project root absolute path
SCRIPT_ABSOLUTE_PATH=$(readlink -f "$0")
PROJECT_ROOT=$(dirname "$SCRIPT_ABSOLUTE_PATH")
echo "[i] Project root is at '$PROJECT_ROOT'"


# build directory path
BUILD_DIR="$PROJECT_ROOT/build"
echo "[i] Build working directory at '$BUILD_DIR'"

# dist directory path
DIST_DIR="$PROJECT_ROOT/dist"
echo "[i] Dist directory at '$DIST_DIR'"


# if arg 0 is clean, clean the build directory
if [ "$1" == "clean" ]; then

    if [ -d "$BUILD_DIR" ]; then
        echo "[i] Cleaning build directory"
        rm -rf "$BUILD_DIR"
    else
        echo "[i] Build directory does not exist"
    fi

    if [ -d "$DIST_DIR" ]; then
        echo "[i] Cleaning dist directory"
        rm -rf "$DIST_DIR"
    else
        echo "[i] Dist directory does not exist"
    fi

    echo "[i] Exiting..."
    exit 0
fi


# create directories
echo "[i] Creating build and dist directories"
mkdir -p "$BUILD_DIR"
mkdir -p "$DIST_DIR"


# build and install to dist directory
export PKG_CONFIG_PATH="$DIST_DIR/lib/pkgconfig"
export CFLGAS="-I$DIST_DIR/include"
export LDFLAGS="-L$DIST_DIR/lib"


######

build_and_install() {
    # function parameters
    local name="$1"
    local repo_url="$2"
    local commit_hash="$3"

    echo "[i] Setting up $name"

    local dir="$BUILD_DIR/$name"
    mkdir -p "$dir"
    cd "$dir"

    # clone the repo if 'autogen.sh' (a part of the repo) does not exist
    if [ ! -f "autogen.sh" ]; then
        echo "[i] Cloning $name from $repo_url to $dir"
        git clone --depth 1 "$repo_url" .

        # checkout commit if commit hash is provided
        if [ -n "$commit_hash" ]; then
            echo "[i] Checking out commit $commit_hash"
            git fetch origin "$commit_hash"
            git checkout "$commit_hash" > /dev/null
        fi

    else
        echo "[w] $name appears to be cloned already; if you want a clean clone, delete the directory at '$dir'"
    fi


    # autogen if config.status (a file created by autogen) does not exist
    if [ ! -f "config.status" ]; then
        echo "[i] Configuring $name"
        ./autogen.sh --prefix="$DIST_DIR"
    else
        echo "[w] $name appears to be configured already; if you want to reconfigure, delete the file at '$dir/config.status'"
    fi


    # build and install if build-install-success.lock (a file created on success) does not exist
    if [ ! -f "build-install-success.lock" ]; then

        echo "[i] Building and installing $name"

        make -j"$(nproc)"
        make install

        touch "build-install-success.lock"

        echo "[i] $name build and install complete"

    else
        echo "[w] $name appears to be built and installed already; if you want to rebuild and install, delete the file at '$dir/build-install-success.lock'"
    fi


    echo "[i] Setup of $name complete"
}


# build libraries
build_and_install "libplist" "https://github.com/libimobiledevice/libplist" "44099d4b79c8d6a7d599d652ebef62db8dae6696"
build_and_install "libimobiledevice-glue" "https://github.com/libimobiledevice/libimobiledevice-glue" "440dbbbf615de11acdd8216df0e3676e8efb9ba1"
build_and_install "libusbmuxd" "https://github.com/libimobiledevice/libusbmuxd" "3fdaed78de8000af3b5d19d953eccd80a208ae2c"
build_and_install "libtatsu" "https://github.com/libimobiledevice/libtatsu" "7e1647b9883ff1daa6363de20af2c4129ed45dcd"
build_and_install "libimobiledevice" "https://github.com/libimobiledevice/libimobiledevice" "c8cdf20fe20b0c46ed7d9a9386bed03301ddbfa5"


echo "[i] Build script completed"
