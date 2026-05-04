(*
 * Topological Sorting using Standard ML
 *
 * Expected input format:
 * First non-empty line: all vertices separated by spaces or commas.
 * Remaining non-empty lines: directed edges as either "A B", "A,B", or "A -> B".
 * Lines beginning with #, or text after #, are treated as comments.
 *)


datatype color = White | Gray | Black;
datatype topo_result = TopologicalOrder of string list | CycleDetected of string list;

fun isSpace c =
    c = #" " orelse c = #"\t" orelse c = #"\n" orelse c = #"\r";

fun trim s =
    let
        val chars = String.explode s

        fun dropLeft [] = []
          | dropLeft (c :: cs) =
                if isSpace c then dropLeft cs else c :: cs

        fun dropRight cs = rev (dropLeft (rev cs))
    in
        String.implode (dropRight (dropLeft chars))
    end;

fun removeComment s =
    let
        fun take [] acc = String.implode (rev acc)
          | take (#"#" :: _) acc = String.implode (rev acc)
          | take (c :: cs) acc = take cs (c :: acc)
    in
        take (String.explode s) []
    end;

fun readAllLines () =
    case TextIO.inputLine TextIO.stdIn of
        NONE => []
      | SOME line => line :: readAllLines ();

fun vertexTokens line =
    String.tokens
        (fn c => isSpace c orelse c = #",")
        line;

fun edgeTokens line =
    String.tokens
        (fn c => isSpace c orelse c = #"," orelse c = #"-" orelse c = #">")
        line;

fun addUnique x xs =
    if List.exists (fn y => y = x) xs then xs else xs @ [x];

fun parseEdge line =
    case edgeTokens line of
        [from, to] => SOME (from, to)
      | [] => NONE
      | _ => raise Fail ("Invalid edge format: " ^ line);

fun parseGraph lines =
    let
        val cleaned = List.map (trim o removeComment) lines
        val useful = List.filter (fn line => line <> "") cleaned

        fun collect [] edges vertices = (vertices, rev edges)
          | collect (line :: rest) edges vertices =
                case parseEdge line of
                    NONE => collect rest edges vertices
                  | SOME (from, to) =>
                        collect rest ((from, to) :: edges)
                            (addUnique to (addUnique from vertices))
    in
        case useful of
            [] => raise Fail "Input must include at least one line of vertices."
          | firstLine :: edgeLines =>
                collect edgeLines [] (vertexTokens firstLine)
    end;

fun neighborsOf edges vertex =
    map #2 (List.filter (fn (from, _) => from = vertex) edges);

fun lookupColor vertex [] = White
  | lookupColor vertex ((name, c) :: rest) =
        if name = vertex then c else lookupColor vertex rest;

fun setColor vertex newColor [] = [(vertex, newColor)]
  | setColor vertex newColor ((name, c) :: rest) =
        if name = vertex
        then (name, newColor) :: rest
        else (name, c) :: setColor vertex newColor rest;

fun dropUntil target [] = []
  | dropUntil target (x :: xs) =
        if x = target then x :: xs else dropUntil target xs;

fun cycleFromPath startVertex path =
    dropUntil startVertex path @ [startVertex];

fun topologicalSort (vertices, edges) =
    let
        fun dfs vertex colors order path =
            let
                val colorsAfterGray = setColor vertex Gray colors
                val newPath = path @ [vertex]

                fun visitNeighbors [] colorsNow orderNow =
                        (setColor vertex Black colorsNow, vertex :: orderNow, NONE)
                  | visitNeighbors (neighbor :: rest) colorsNow orderNow =
                        case lookupColor neighbor colorsNow of
                            Gray =>
                                (colorsNow, orderNow, SOME (cycleFromPath neighbor newPath))
                          | Black =>
                                visitNeighbors rest colorsNow orderNow
                          | White =>
                                let
                                    val (colorsAfterDfs, orderAfterDfs, cycleOption) =
                                        dfs neighbor colorsNow orderNow newPath
                                in
                                    case cycleOption of
                                        SOME cycle => (colorsAfterDfs, orderAfterDfs, SOME cycle)
                                      | NONE => visitNeighbors rest colorsAfterDfs orderAfterDfs
                                end
            in
                visitNeighbors (neighborsOf edges vertex) colorsAfterGray order
            end

        fun visitVertices [] colors order = TopologicalOrder order
          | visitVertices (vertex :: rest) colors order =
                case lookupColor vertex colors of
                    Black => visitVertices rest colors order
                  | Gray => CycleDetected [vertex, vertex]
                  | White =>
                        let
                            val (newColors, newOrder, cycleOption) = dfs vertex colors order []
                        in
                            case cycleOption of
                                SOME cycle => CycleDetected cycle
                              | NONE => visitVertices rest newColors newOrder
                        end
    in
        visitVertices vertices [] []
    end;

fun joinWith sep [] = ""
  | joinWith sep [x] = x
  | joinWith sep (x :: xs) = x ^ sep ^ joinWith sep xs;

fun printResult result =
    case result of
        TopologicalOrder order =>
            print ("Topological order: " ^ joinWith " -> " order ^ "\n")
      | CycleDetected cycle =>
            print ("Cycle detected: " ^ joinWith " -> " cycle ^ "\n");

fun main () =
    let
        val graph = parseGraph (readAllLines ())
        val result = topologicalSort graph
    in
        printResult result
    end;

val _ = main ();
