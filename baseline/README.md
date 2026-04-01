# Scudo Hardened Allocator (Baseline)

This directory contains an unmodified MTE-enabled Scudo allocator from [LLVM 19.1.7](https://github.com/llvm/llvm-project/tree/llvmorg-19.1.7), used as the baseline for comparison with NanoTag.

Scudo with MTE enabled detects buffer overflows at 16-byte granularity: a fault is raised when a pointer's tag mismatches the tag of the 16-byte tag granule it accesses. Overflows that stay within the same granule as the allocation (intra-granule overflows) are not detected.

## Build

```sh
mkdir -p ~/baseline-runtime
cd baseline

clang++ -fPIC -std=c++17 -march=armv8.5-a+memtag -msse4.2 -O2 -pthread -shared \
  -I scudo/standalone/include -D SCUDO_USE_MTE_SYNC \
  scudo/standalone/*.cpp \
  -o ~/baseline-runtime/libscudo.so

cd -
```

## Usage

```sh
LD_PRELOAD=~/baseline-runtime/libscudo.so <your_program>
```
