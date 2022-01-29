#!/bin/bash

SRC="./jemalloc_src"
BUILD="./jemalloc_build"


# Handle arguments
function show_help {
    echo "Usage: $0 JEMALLOC_VERSION [-h|--help]"
}

if [[ $# < 1 ]]; then
    show_help
    exit 1
fi

JEMALLOC_VERSION=''

while :; do
    case $1 in
        -h|-\?|--help)
            show_help
            exit
            ;;
        '')
            break
            ;;
        *)
            if [ ! -z $JEMALLOC_VERSION ]; then
                echo "Error: Unknow option $1"
                exit 1
            fi
            JEMALLOC_VERSION="$1"
            ;;
    esac

    shift
done

if [ -z $JEMALLOC_VERSION ]; then
    echo 'Error: First argument must be glibc version'
    show_help
    exit 1
fi

# Get glibc source
if [ ! -d "$SRC" ]; then
    git clone https://github.com/jemalloc/jemalloc.git "$SRC"
fi
cd "$SRC"
git pull --all

# Checkout tags
git rev-parse --verify --quiet "tags/$JEMALLOC_VERSION"
if [[ $? != 0 ]]; then
    echo "Error: Jemalloc version \"$JEMALLOC_VERSION\" does not seem to exists"
    exit 1
fi

git checkout "tags/$JEMALLOC_VERSION" -f

# Autoconf
autoconf
cd -

# Prepare build directory
mkdir -p "$BUILD"
cd "$BUILD"
mkdir -p "$JEMALLOC_VERSION"
cd "$JEMALLOC_VERSION"

# Compilation
eval ../../"$SRC/configure --enable-autoconf --enable-debug"
make
cd -