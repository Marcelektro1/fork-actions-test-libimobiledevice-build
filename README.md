# libimobiledevice build

A script for building libimobiledevice-related repositories  


## Usage

Build using `bash ./build.sh`  
The script will clone the source repositories and build them.

Repositories are cloned and checked out at specific commit hashes, which are defined in the script.


## Repositories
- [libplist](https://github.com/libimobiledevice/libplist)
- [libimobiledevice-glue](https://github.com/libimobiledevice/libimobiledevice-glue)
- [libusbmuxd](https://github.com/libimobiledevice/libusbmuxd)
- [libtatsu](https://github.com/libimobiledevice/libtatsu)
- [libimobiledevice](https://github.com/libimobiledevice/libimobiledevice)


## Dependencies
- git
- gcc
- make
- automake
- libtool
- autoconf
- pkg-config
- libssl-dev
- libcurl4-openssl-dev
- *(optional)* python3 with Cython 3.0.0 or newer


## Contact
If you have any questions or suggestions, let me know on [my Discord](https://marcloud.net/discord)! ^^
