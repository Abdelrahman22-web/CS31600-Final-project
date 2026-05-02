import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

/**
 * Performs DFS-based topological sorting and cycle detection.
 */
public class TopoSorter {
    private enum VisitState {
        UNVISITED,
        VISITING,
        VISITED
    }

    private final Graph graph;
    private final Map<String, VisitState> states;
    private final List<String> path;
    private final LinkedList<String> order;

    public TopoSorter(Graph graph) {
        this.graph = graph;
        this.states = new HashMap<>();
        this.path = new ArrayList<>();
        this.order = new LinkedList<>();

        for (String vertex : graph.vertices()) {
            states.put(vertex, VisitState.UNVISITED);
        }
    }

    public TopoSortResult sort() {
        for (String vertex : graph.vertices()) {
            if (stateOf(vertex) == VisitState.UNVISITED) {
                List<String> cycle = dfs(vertex);
                if (cycle != null) {
                    return TopoSortResult.cycleDetected(cycle);
                }
            }
        }

        return TopoSortResult.topologicalOrder(order);
    }

    private List<String> dfs(String vertex) {
        states.put(vertex, VisitState.VISITING);
        path.add(vertex);

        for (String neighbor : graph.neighborsOf(vertex)) {
            VisitState neighborState = stateOf(neighbor);

            if (neighborState == VisitState.VISITING) {
                return buildCycle(neighbor);
            }

            if (neighborState == VisitState.UNVISITED) {
                List<String> cycle = dfs(neighbor);
                if (cycle != null) {
                    return cycle;
                }
            }
        }

        path.remove(path.size() - 1);
        states.put(vertex, VisitState.VISITED);
        order.addFirst(vertex);
        return null;
    }

    private VisitState stateOf(String vertex) {
        return states.getOrDefault(vertex, VisitState.UNVISITED);
    }

    private List<String> buildCycle(String repeatedVertex) {
        int startIndex = path.indexOf(repeatedVertex);
        List<String> cycle = new ArrayList<>(path.subList(startIndex, path.size()));
        cycle.add(repeatedVertex);
        return cycle;
    }
}
