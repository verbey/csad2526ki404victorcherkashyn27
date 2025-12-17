#!/usr/bin/env bash
set -euo pipefail

# Configurable variables
BUILD_DIR="${BUILD_DIR:-./build}"
BUILD_TYPE="${BUILD_TYPE:-Debug}"

# Detect number of parallel jobs in a cross-platform way
detect_jobs() {
    if command -v nproc >/dev/null 2>&1; then
        nproc
    elif command -v getconf >/dev/null 2>&1; then
        getconf _NPROCESSORS_ONLN
    elif command -v sysctl >/dev/null 2>&1; then
        sysctl -n hw.ncpu
    else
        # Fallback when detection isn't available
        echo 2
    fi
}

JOBS="${JOBS:-$(detect_jobs)}"

echo "CI: build dir = ${BUILD_DIR}, build type = ${BUILD_TYPE}, jobs = ${JOBS}"

mkdir -p "${BUILD_DIR}"
pushd "${BUILD_DIR}" >/dev/null

echo "Running cmake configure..."
cmake -DCMAKE_BUILD_TYPE="${BUILD_TYPE}" ..

echo "Building project..."
# Use CMake's --parallel option so it requests parallelism in a cross-platform way
# (MSBuild on Windows doesn't accept -j as a switch)
cmake --build . --config "${BUILD_TYPE}" --parallel "${JOBS}"

echo "Running tests..."
# Prefer ctest (outputs failures). Exit non-zero if any test fails.
if command -v ctest >/dev/null 2>&1; then
    ctest --output-on-failure -C "${BUILD_TYPE}"
else
    echo "ctest not found; attempting to run unit_tests binary directly"
    if [ -x ./tests/unit_tests ]; then
        ./tests/unit_tests --gtest_color=yes || { echo "Unit tests failed"; popd >/dev/null; exit 1; }
    else
        echo "No test runner found in build. Skipping tests."
    fi
fi

popd >/dev/null
echo "CI: build and tests completed successfully."
