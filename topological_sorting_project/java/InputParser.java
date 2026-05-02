import java.io.BufferedReader;
import java.io.IOException;

/**
 * Parses graph input from standard input.
 *
 * Expected format:
 * First non-empty line: all vertices separated by spaces or commas.
 * Remaining non-empty lines: directed edges as either "A B", "A,B", or "A -> B".
 * Lines beginning with #, or text after #, are treated as comments.
 */
public class InputParser {
    public Graph parse(BufferedReader reader) throws IOException {
        Graph graph = new Graph();
        boolean readVertexLine = false;
        String line;

        while ((line = reader.readLine()) != null) {
            line = removeComment(line).trim();

            if (line.isEmpty()) {
                continue;
            }

            if (!readVertexLine) {
                parseVertices(line, graph);
                readVertexLine = true;
            } else {
                parseEdge(line, graph);
            }
        }

        if (!readVertexLine) {
            throw new IllegalArgumentException("Input must include at least one line of vertices.");
        }

        return graph;
    }

    private void parseVertices(String line, Graph graph) {
        line = line.replace(",", " ");
        String[] vertices = line.trim().split("\\s+");

        for (String vertex : vertices) {
            graph.addVertex(vertex);
        }
    }

    private void parseEdge(String line, Graph graph) {
        String from;
        String to;

        if (line.contains("->")) {
            String[] parts = line.split("\\s*->\\s*");
            if (parts.length != 2) {
                throw new IllegalArgumentException("Invalid edge format: " + line);
            }
            from = parts[0];
            to = parts[1];
        } else {
            line = line.replace(",", " ");
            String[] parts = line.trim().split("\\s+");
            if (parts.length != 2) {
                throw new IllegalArgumentException("Invalid edge format: " + line);
            }
            from = parts[0];
            to = parts[1];
        }

        graph.addEdge(from, to);
    }

    private String removeComment(String line) {
        int commentStart = line.indexOf('#');
        if (commentStart >= 0) {
            return line.substring(0, commentStart);
        }
        return line;
    }
}
