import java.io.BufferedReader;
import java.io.InputStreamReader;

/**
 * Handles input and output only.
 */
public class Main {
    public static void main(String[] args) {
        try {
            BufferedReader reader = new BufferedReader(new InputStreamReader(System.in));
            Graph graph = new InputParser().parse(reader);
            TopoSortResult result = new TopoSorter(graph).sort();
            System.out.println(result.format());
        } catch (Exception exception) {
            System.err.println("Input error: " + exception.getMessage());
            System.exit(1);
        }
    }
}
