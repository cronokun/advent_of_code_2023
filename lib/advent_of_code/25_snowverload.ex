defmodule AdventOfCode.Snowverload.Graph do
  @moduledoc "Graph implementation."

  alias AdventOfCode.Utils.Queue

  def new, do: %{}

  def put_node(graph, node, connected_nodes) do
    Enum.reduce(connected_nodes, graph, fn node_b, acc ->
      acc
      |> update_in([node], &[node_b | &1 || []])
      |> update_in([node_b], &[node | &1 || []])
    end)
  end

  def cut_edge(graph, [a, b]) do
    graph
    |> update_in([a], &(&1 -- [b]))
    |> update_in([b], &(&1 -- [a]))
  end

  # ---- Shortest path --------

  def shortest_traverse(graph, node_a, node_b, acc \\ %{}) do
    queue = Queue.new()
    visited = MapSet.new()
    do_short_traverse({0, node_a, []}, queue, visited, node_b, graph, acc)
  end

  defp do_short_traverse({_steps, target, path}, _queue, _visited, target, _graph, acc) do
    [target | path]
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.reduce(acc, fn [a, b], facc ->
      Map.update(facc, edge_name(a, b), 1, &(&1 + 1))
    end)
  end

  defp do_short_traverse({steps, node, path}, queue, visited, target, graph, acc) do
    visited = MapSet.put(visited, node)

    neighbours =
      graph[node]
      |> Enum.reject(&MapSet.member?(visited, &1))
      |> Enum.map(&{steps + 1, &1, [node | path]})

    {next, queue} = Queue.enqueue(queue, neighbours) |> Queue.pop()
    do_short_traverse(next, queue, visited, target, graph, acc)
  end

  # ---- Weight --------

  def nodes_total(graph, node) do
    count_nodes(graph, [node], MapSet.new(), 0)
  end

  defp count_nodes(_graph, [], _visited, acc), do: acc

  defp count_nodes(graph, [node | rest], visited, acc) do
    visited = MapSet.put(visited, node)

    next =
      Enum.reject(graph[node], fn n ->
        MapSet.member?(visited, n) or MapSet.member?(MapSet.new(rest), n)
      end)

    count_nodes(graph, next ++ rest, visited, acc + 1)
  end

  defp edge_name(a, b), do: Enum.sort([a, b])
end

defmodule AdventOfCode.Snowverload do
  @moduledoc """
  # Day 25: Snowverload

  ## Part One

  Still somehow without snow, you go to the last place you haven't checked: the center of Snow
  Island, directly below the waterfall.

  Here, someone has clearly been trying to fix the problem. Scattered everywhere are hundreds of
  weather machines, almanacs, communication modules, hoof prints, machine parts, mirrors, lenses,
  and so on.

  Somehow, everything has been wired together into a massive snow-producing apparatus, but nothing
  seems to be running. You check a tiny screen on one of the communication modules: `Error 2023`.
  It doesn't say what `Error 2023` means, but it does have the phone number for a support lin
  printed on it.

  "Hi, you've reached Weather Machines And So On, Inc. How can I help you?" You explain the
  situation.

  "Error 2023, you say? Why, that's a power overload error, of course! It means you have too many
  components plugged in. Try unplugging some components and--" You explain that there are hundreds
  of components here and you're in a bit of a hurry.

  "Well, let's see how bad it is; do you see a big red reset button somewhere? It should be on its
  own module. If you push it, it probably won't fix anything, but it'll report how overloaded
  things are." After a minute or two, you find the reset button; it's so big that it takes two
  hands just to get enough leverage to push it. Its screen then displays:

      SYSTEM OVERLOAD!

      Connected components would require
      power equal to at least 100 stars!

  "Wait, how many components did you say are plugged in? With that much equipment, you could
  produce snow for an entire--" You disconnect the call.

  You have nowhere near that many stars - you need to find a way to disconnect at least half of
  the equipment here, but it's already Christmas! You only have time to disconnect three wires.

  Fortunately, someone left a wiring diagram (your puzzle input) that shows how the components
  are connected. For example:

      jqt: rhn xhk nvd
      rsh: frs pzl lsr
      xhk: hfx
      cmg: qnr nvd lhk bvb
      rhn: xhk bvb hfx
      bvb: xhk hfx
      pzl: lsr hfx nvd
      qnr: nvd
      ntq: jqt hfx bvb xhk
      nvd: lhk
      lsr: lhk
      rzs: qnr cmg lsr rsh
      frs: qnr lhk lsr

  Each line shows the name of a component, a colon, and then a list of other components to which
  that component is connected. Connections aren't directional; abc: xyz and xyz: abc both
  represent the same configuration. Each connection between two components is represented only
  once, so some components might only ever appear on the left or right side of a colon.

  In this example, if you disconnect the wire between `hfx/pzl`, the wire between `bvb/cmg`, and
  the wire between nvd/jqt, you will divide the components into two separate, disconnected groups:

  - 9 components: cmg, frs, lhk, lsr, nvd, pzl, qnr, rsh, and rzs.
  - 6 components: bvb, hfx, jqt, ntq, rhn, and xhk.

  Multiplying the sizes of these groups together produces `54`.

  Find the three wires you need to disconnect in order to divide the components into two separate
  groups. What do you get if you multiply the sizes of these two groups together?
  """

  alias AdventOfCode.Snowverload.Graph

  @doc "Splits graph in two and multiplies sizes of two groups."
  def answer(input) do
    graph = input |> parse()
    [[a, b] | _] = cuts = most_visited_edges(graph)
    new_graph = Enum.reduce(cuts, graph, fn edge, gacc -> Graph.cut_edge(gacc, edge) end)
    Graph.nodes_total(new_graph, a) * Graph.nodes_total(new_graph, b)
  end

  defp most_visited_edges(graph) do
    keys = Map.keys(graph)

    Enum.reduce(1..500, %{}, fn _n, acc ->
      [a, b] = Enum.take_random(keys, 2)
      Graph.shortest_traverse(graph, a, b, acc)
    end)
    |> take_top_n(3)
  end

  defp take_top_n(counts, n) do
    counts
    |> Enum.sort_by(fn {_, t} -> t end, :desc)
    |> Enum.take(n)
    |> Enum.map(&elem(&1, 0))
  end

  # ---- Parser --------

  defp parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.reduce(Graph.new(), &parse_line/2)
  end

  defp parse_line(line, graph) do
    [comp, right] = String.split(line, ": ")
    connected = String.split(right, " ")
    Graph.put_node(graph, comp, connected)
  end
end
