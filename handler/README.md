# Tag Mismatch Handler

This directory contains NanoTag's custom tag mismatch handler for detecting byte-granular buffer overflows.

When ARM MTE raises a synchronous tag mismatch fault (SIGSEGV), the handler intercepts it, decodes the faulting ARM64 instruction to extract the accessed address and size, and performs a software check against per-byte metadata stored by NanoTag's custom Scudo allocator. This enables detection of intra-granule overflows that hardware MTE alone cannot catch.

## Files

- `handler.h` — constants (instruction format, thresholds, etc.)
- `handler.c` — signal handler implementation; instruction decoder; short-granule byte-granular check logic

## Build

```sh
mkdir -p ~/mte-sanitizer-runtime
cd handler

clang -shared -fPIC -march=armv8.5-a+memtag \
  -DINTERCEPT_SIGNAL_HANDLER -DFOPEN_INTERCEPT -DENABLE_DETAILED_REPORT \
  -o ~/mte-sanitizer-runtime/handler.so handler.c

cd -
```

## Configuration

| Environment Variable        | Description                                              | Default |
|-----------------------------|----------------------------------------------------------|---------|
| `MTE_SANITIZER_THRESHOLD`   | Max accesses checked per short granule before disabling  | 1000    |
