# Samples

This directory contains two sample programs that demonstrate NanoTag's byte-granular overflow detection capabilities compared to the baseline MTE-enabled Scudo allocator.

## Sample Programs

### `test_oob_cross_granule.c`

Allocates a 5-byte array and accesses index 20, which falls outside the 16-byte MTE granule containing the allocation. Both NanoTag and the baseline MTE-enabled Scudo detect this overflow.

### `test_oob_short_granule.c`

Allocates a 5-byte array and accesses index 10, which falls within the same 16-byte MTE granule as the allocation but beyond the allocated 5 bytes. This is an **intra-granule buffer overflow** that the baseline MTE-enabled Scudo misses but NanoTag detects.

## Build

```sh
clang test_oob_cross_granule.c -o test_oob_cross_granule
clang test_oob_short_granule.c -o test_oob_short_granule
```

## Run

### With NanoTag

```sh
LD_PRELOAD=~/mte-sanitizer-runtime/handler.so:~/mte-sanitizer-runtime/libscudo.so ./test_oob_cross_granule
LD_PRELOAD=~/mte-sanitizer-runtime/handler.so:~/mte-sanitizer-runtime/libscudo.so ./test_oob_short_granule
```

Both overflows are detected. For `test_oob_short_granule`, the report identifies the short granule:

```
Tag Mismatch Fault (SYNC). PC: 0x60b9f107fc, Instruction: 0x39402901, Fault Address: 0x40b9f16c1a, Memory Tag: 0x3, Address Tag: 0x3
Short Granule. Permitted Bytes: 5, Short Granule Start Byte: 10
[Register File Dump]
```

### With Baseline MTE-Enabled Scudo

```sh
LD_PRELOAD=~/baseline-runtime/libscudo.so ./test_oob_cross_granule  # Detected
LD_PRELOAD=~/baseline-runtime/libscudo.so ./test_oob_short_granule  # Not detected
```

The cross-granule overflow triggers a segfault, but the short granule overflow goes undetected.

## Summary

| Sample | Overflow Type | Baseline MTE | NanoTag |
|--------|--------------|-------------|---------|
| `test_oob_cross_granule` | Cross-granule (index 20, 5-byte alloc) | Detected | Detected |
| `test_oob_short_granule` | Intra-granule / short granule (index 10, 5-byte alloc) | Not detected | Detected |
