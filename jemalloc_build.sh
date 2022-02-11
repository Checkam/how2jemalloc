#!/bin/bash

ROOT_DIR="$(pwd)"
SRC="./jemalloc_src"
BUILD="./jemalloc_build"


# Handle arguments
function show_help {
    echo "Usage: $0 JEMALLOC_VERSION [-h|--help] [--enable-debug]"
}

if [[ $# < 1 ]]; then
    show_help
    exit 1
fi

BUILD_OPTS=''
JEMALLOC_VERSION=''
DEBUG_ENABLED=false

while :; do
    case $1 in
        -h|-\?|--help)
            show_help
            exit
            ;;
        --enable-debug)
            # Use EXTRA_CFLAGS instead of '--enable-debug' because '--enable-debug' add assertions that mask some segmentation fault.
            echo '  -> Enabling debug'
            BUILD_OPTS="$BUILD_OPTS EXTRA_CFLAGS=-O0 EXTRA_CXXFLAGS=-O0"
            DEBUG_ENABLED=true
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
    echo 'Error: First argument must be jemalloc version'
    show_help
    exit 1
fi

OUTPUT_DIR="$JEMALLOC_VERSION"
if [ "$DEBUG_ENABLED" = true ]; then
    OUTPUT_DIR=$OUTPUT_DIR"_DEBUG"
fi

# Get jemalloc source
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
mkdir -p "$OUTPUT_DIR"
cd "$OUTPUT_DIR"

# Compilation
eval $BUILD_OPTS ../../"$SRC"/configure
make
cd "$ROOT_DIR"

# Copy include/ and lib/ directories to a corresponding directory of techniques if it exists
DEST_DIR="jemalloc_"$JEMALLOC_VERSION
if [ -d "$DEST_DIR" ] 
then
    SRC_DIR=$BUILD"/"$OUTPUT_DIR

    echo "  -> Copying $SRC_DIR/include/ and $SRC_DIR/lib/ to $DEST_DIR"
    cp -r "$SRC_DIR/include/" "$SRC_DIR/lib/" $DEST_DIR
else
    echo "Info: No directory of techniques found to copy include/ and lib/ directories for jemalloc version $JEMALLOC_VERSION"
fi