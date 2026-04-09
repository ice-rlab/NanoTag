#!/bin/bash
set +e

echo "============================================================"
echo "Sample: test_oob_cross_granule"
echo "Overflow Type: Cross-granule (index 20, 5-byte alloc)"
echo "============================================================"

echo "[NanoTag] Expected result: Detected"
echo "*******************************************************"
LD_PRELOAD=~/mte-sanitizer-runtime/handler.so:~/mte-sanitizer-runtime/libscudo.so ./samples/test_oob_cross_granule
echo "[NanoTag] exit code: $?"
echo

echo "============================================================"

echo "[Baseline MTE] Expected result: Detected"
echo "*******************************************************"
LD_PRELOAD=~/baseline-runtime/libscudo.so ./samples/test_oob_cross_granule
echo "[Baseline MTE] exit code: $?"
echo

echo "============================================================"
echo "Sample: test_oob_short_granule"
echo "Overflow Type: Intra-granule / short granule (index 10, 5-byte alloc)"
echo "============================================================"

echo "[NanoTag] Expected result: Detected"
echo "*******************************************************"
LD_PRELOAD=~/mte-sanitizer-runtime/handler.so:~/mte-sanitizer-runtime/libscudo.so ./samples/test_oob_short_granule
echo "[NanoTag] exit code: $?"
echo

echo "============================================================"

echo "[Baseline MTE] Expected result: Not detected"
echo "*******************************************************"
LD_PRELOAD=~/baseline-runtime/libscudo.so ./samples/test_oob_short_granule
echo "[Baseline MTE] exit code: $?"
echo
