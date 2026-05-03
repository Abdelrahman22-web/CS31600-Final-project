# Topological Sorting Using Java and SML

## Problem Summary

This project solves topological sorting for a directed graph. Each directed edge represents a dependency. For example, `A -> B` means `A` must happen before `B`.

The program outputs exactly one of two results:

- a valid topological order if the graph is acyclic, or
- a detected cycle if the graph contains a cycle.

## Algorithm Summary

Both implementations use depth-first search with three visit states:

- `unvisited`
- `visiting`
- `visited`

A cycle is detected when DFS reaches a vertex already in the `visiting` state, which indicates a back edge on the current recursion path.

If no cycle is found, each vertex is added to the front of the order after all outgoing edges are fully explored. This guarantees each vertex appears before vertices that depend on it.

## Design Comparison

Data representation:

- Java uses a `Graph` class with an adjacency list backed by `LinkedHashMap`.
- SML uses a functional representation with a vertex list and edge-pair list.

Control flow:

- Java uses object-oriented DFS with mutable structures for visit state, recursion path, and result order.
- SML uses recursive functions and pattern matching to perform the same traversal logic.

Structural organization:

- Java splits responsibilities across classes (`Graph`, `InputParser`, `TopoSorter`, `TopoSortResult`, `Main`).
- SML organizes parsing, helpers, DFS, and output as function definitions within one file.

## AI Usage Disclosure

AI assistance (ChatGPT) was used to clarify assignment expectations and to shape initial structure for both Java and SML implementations.

The resulting code was reviewed and adjusted to match requirements, including:

- keeping Java `Main` focused on input/output,
- separating algorithm logic into dedicated components,
- ensuring each run prints exactly one result type (`Topological order` or `Cycle detected`),
- validating behavior on both acyclic and cyclic sample inputs.

Key learning outcome:

- The same algorithm can be expressed through object-oriented design in Java and functional recursion/pattern matching in SML while preserving the same correctness behavior.
