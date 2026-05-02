import java.util.ArrayList;
import java.util.Collections;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

/**
 * Stores a directed graph using an adjacency list.
 * The graph preserves insertion order so the output is predictable.
 */
public class Graph {
    private final Map<String, List<String>> adjacencyList;

    public Graph() {
        this.adjacencyList = new LinkedHashMap<>();
    }

    public void addVertex(String vertex) {
        if (vertex == null || vertex.isBlank()) {
            throw new IllegalArgumentException("Vertex name cannot be empty.");
        }
        adjacencyList.putIfAbsent(vertex.trim(), new ArrayList<>());
    }

    public void addEdge(String from, String to) {
        addVertex(from);
        addVertex(to);

        List<String> neighbors = adjacencyList.get(from.trim());
        String destination = to.trim();

        if (!neighbors.contains(destination)) {
            neighbors.add(destination);
        }
    }

    public Set<String> vertices() {
        return Collections.unmodifiableSet(adjacencyList.keySet());
    }

    public List<String> neighborsOf(String vertex) {
        List<String> neighbors = adjacencyList.get(vertex);
        if (neighbors == null) {
            return Collections.emptyList();
        }
        return Collections.unmodifiableList(neighbors);
    }
}
