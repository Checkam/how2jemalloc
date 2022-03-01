# how2jemalloc
List of exploitation techniques on vulnerabilities in programs using jemalloc

# Installation

## Requirements
- autoconf

## Build jemalloc
```
chmod +x jemalloc_build.sh
./jemalloc_build.sh <JEMALLOC_VERSION>
```

include/ and lib/ directories are automatically copied in corresponding folder version if it exists.

## Build techniques
```
cd jemalloc_VERSION/
make
```
