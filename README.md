# Topological Sorting using Java and SML

This project solves topological sorting for a directed graph in both Java and SML.

The program prints exactly one of the following:

```text
Topological order: A -> C -> B -> D
```

or

```text
Cycle detected: B -> D -> F -> B
```

## Input Format

Because the assignment did not specify an input format, this project uses a simple text format:

1. The first non-empty line contains all vertices separated by spaces or commas.
2. Each remaining non-empty line contains one directed edge.
3. Edge formats supported:
   - `A -> B`
   - `A B`
   - `A,B`
4. `#` can be used for comments.

Example:

```text
A B C D
A -> B
A -> C
B -> D
C -> D
```

## Java Version

Go into the Java folder:

```bash
cd java
javac *.java
java Main < ../samples/acyclic.txt
java Main < ../samples/cyclic.txt
```

## SML Version

With SML/NJ installed, run from the main project folder:

```bash
sml sml/TopoSort.sml < samples/acyclic.txt
sml sml/TopoSort.sml < samples/cyclic.txt
```

## Files

```text
java/Graph.java
java/InputParser.java
java/Main.java
java/TopoSorter.java
java/TopoSortResult.java
sml/TopoSort.sml
samples/acyclic.txt
samples/cyclic.txt
report/Topological_Sorting_Report.docx
```

## Algorithm

Both implementations use depth-first search with three states:

- White / unvisited: vertex has not been explored yet.
- Gray / visiting: vertex is currently on the recursion path.
- Black / visited: vertex and all of its outgoing edges are finished.

If DFS reaches a gray vertex, a cycle exists. If no cycle is found, vertices are added to the front of the order when DFS finishes them, producing a valid topological order.
