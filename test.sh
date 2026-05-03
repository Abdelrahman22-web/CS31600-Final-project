#!/usr/bin/env bash
# Test script for topological sorting project
# Run: ./test.sh

set -euo pipefail

SCRIPT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$SCRIPT_ROOT/topological_sorting_project"
JAVA_ROOT="$PROJECT_ROOT/java"
SAMPLE_ROOT="$PROJECT_ROOT/samples"

cleanup_java_classes() {
  find "$JAVA_ROOT" -maxdepth 1 -type f -name "*.class" -delete
}

run_java_sample() {
  local sample="$1"
  local sample_path="$SAMPLE_ROOT/$sample"
  echo "Input file: $sample_path"
  java Main < "$sample_path"
}

run_sml_sample() {
  local sample="$1"
  local sample_path="$SAMPLE_ROOT/$sample"
  echo "Input file: $sample_path"
  sml sml/TopoSort.sml < "$sample_path"
}

echo "=== Topological Sorting Project Test Suite ==="
echo ""

echo "Testing Java implementation..."
pushd "$JAVA_ROOT" >/dev/null
trap cleanup_java_classes EXIT

echo "Compiling Java files..."
javac *.java

echo ""
echo "Test 1: Java acyclic graph"
run_java_sample "acyclic.txt"

echo ""
echo "Test 2: Java cyclic graph"
run_java_sample "cyclic.txt"

echo ""
echo "=== Java tests passed ==="
echo ""

popd >/dev/null

if command -v sml >/dev/null 2>&1; then
  echo "Testing SML implementation..."
  pushd "$PROJECT_ROOT" >/dev/null

  echo ""
  echo "Test 3: SML acyclic graph"
  run_sml_sample "acyclic.txt"

  echo ""
  echo "Test 4: SML cyclic graph"
  run_sml_sample "cyclic.txt"

  popd >/dev/null
  echo ""
  echo "=== SML tests passed ==="
else
  echo "SML/NJ not found on PATH; skipping SML tests."
fi

echo ""
echo "All tests completed successfully!"
