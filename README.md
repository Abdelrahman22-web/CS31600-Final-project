# Topological Sorting Using Java and SML

This project solves topological sorting for directed graphs in both Java and Standard ML.

Each program prints exactly one result:

- `Topological order: ...` for acyclic graphs.
- `Cycle detected: ...` for cyclic graphs.

## Input Format

The parser accepts a simple text format:

1. The first non-empty line lists vertices (space or comma separated).
2. Remaining non-empty lines list directed edges.
3. Supported edge formats:
   - `A -> B`
   - `A B`
   - `A,B`
4. `#` starts a comment (full-line or inline).

Example:

```text
A B C D
A -> B
A -> C
B -> D
C -> D
```

## Quick Start

From the repository root:

### Windows (PowerShell)

```powershell
powershell -ExecutionPolicy Bypass -File .\test.ps1
```

### macOS/Linux

```bash
chmod +x ./test.sh
./test.sh
```

The test scripts compile and validate Java on acyclic/cyclic samples, and run SML tests when `sml` is available on `PATH`.

## Manual Run

### Java

```bash
cd topological_sorting_project/java
javac *.java
java Main < ../samples/acyclic.txt
java Main < ../samples/cyclic.txt
```

### SML

```bash
cd topological_sorting_project
sml sml/TopoSort.sml < samples/acyclic.txt
sml sml/TopoSort.sml < samples/cyclic.txt
```

## File Layout

```text
Topological_Sorting_Report.md
topological_sorting_project/
|- java/
|  |- Graph.java
|  |- InputParser.java
|  |- Main.java
|  |- TopoSorter.java
|  `- TopoSortResult.java
|- sml/
|  `- TopoSort.sml
`- samples/
   |- acyclic.txt
   `- cyclic.txt
```

## Design Comparison

Based on the assignment details:

- Data representation:
  - Java uses a `Graph` class with `LinkedHashMap<String, List<String>>`.
  - SML uses `(vertices, edges)` data passed through functions.
- Control flow:
  - Java uses object-oriented DFS with mutable state maps/lists.
  - SML uses recursive functions and pattern matching.
- Organization:
  - Java separates concerns across classes (`Graph`, parser, sorter, result, `Main`).
  - SML keeps the same logic in composable functions inside one file.

## AI Usage Disclosure

AI assistance (ChatGPT) was used during development for clarifying requirements, structuring Java classes, and shaping the equivalent SML implementation. The final code and documentation were reviewed and adjusted to satisfy assignment expectations, including:

- clear algorithm separation from Java I/O,
- cycle detection + topological ordering behavior,
- consistent output contract (`Topological order` or `Cycle detected`).
