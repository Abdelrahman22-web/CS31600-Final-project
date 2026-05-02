import java.util.List;

/**
 * Represents exactly one possible result:
 * 1. a valid topological order, or
 * 2. a detected cycle.
 */
public class TopoSortResult {
    private final List<String> topologicalOrder;
    private final List<String> cycle;

    private TopoSortResult(List<String> topologicalOrder, List<String> cycle) {
        this.topologicalOrder = topologicalOrder;
        this.cycle = cycle;
    }

    public static TopoSortResult topologicalOrder(List<String> order) {
        return new TopoSortResult(List.copyOf(order), null);
    }

    public static TopoSortResult cycleDetected(List<String> cycle) {
        return new TopoSortResult(null, List.copyOf(cycle));
    }

    public boolean hasCycle() {
        return cycle != null;
    }

    public List<String> getTopologicalOrder() {
        return topologicalOrder;
    }

    public List<String> getCycle() {
        return cycle;
    }

    public String format() {
        if (hasCycle()) {
            return "Cycle detected: " + String.join(" -> ", cycle);
        }
        return "Topological order: " + String.join(" -> ", topologicalOrder);
    }
}
