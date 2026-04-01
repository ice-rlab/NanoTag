# Custom Scudo Hardened Allocator

This directory contains NanoTag's modified Scudo hardened allocator. It extends the [baseline](../baseline/) with sampling-based tripwire allocation to support intra-granule overflow detection.

## Key Modifications

- **Slow-start phase**: all short granules are allocated a tripwire until `AllocThreshold` is reached.
- **Sampling phase**: after the slow-start phase, only a 1-in-`SamplingRate` fraction of short granules are allocated a tripwire.

## Build

```sh
mkdir -p ~/mte-sanitizer-runtime
cd scudo

clang++ -fPIC -std=c++17 -march=armv8.5-a+memtag -msse4.2 -O2 -pthread -shared \
  -I standalone/include \
  standalone/*.cpp \
  -o ~/mte-sanitizer-runtime/libscudo.so

cd -
```

## Configuration

| Environment Variable      | Description                                              | Default |
|---------------------------|----------------------------------------------------------|---------|
| `SCUDO_ALLOCA_THRESHOLD`  | Number of allocations in the slow-start phase            | 1000    |
| `SCUDO_SAMPLING_RATE`     | Sampling rate after slow-start      | 1000    |
