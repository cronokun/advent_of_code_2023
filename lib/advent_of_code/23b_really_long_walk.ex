defmodule AdventOfCode.ReallyLongWalk.Graph do
  @moduledoc """
  This module represents hiking trails as a graph structure with vertices (intersections) and
  edges (straight pathes).

  The graph is builded in one pathtrough. Next start and end vertices are contracted:

                B                  B
               / \                / \
      Start - A   D - End  ===>  A   D
               \ /                \ /
                C                  C
  """

  defstruct verts: %{}, edges: %{}, start: nil, target: nil

  def build(input, start, target) do
    %__MODULE__{
      start: start,
      target: target
    }
    |> prepare(input)
  end

  def get_edge_length(g, {a, b}), do: g.edges[edge_key(a, b)]

  defp prepare(g, input) do
    g = traverse(g, input, [{g.start, g.start}], g.target, MapSet.new())
    {new_start, g} = compact_graph(g, g.start)
    {new_end, g} = compact_graph(g, g.target)
    %{g | start: new_start, target: new_end}
  end

  defp traverse(g, _input, [], _target, _walked), do: g

  defp traverse(g, input, [{loc, prev_vert} | next], target, walked) do
    {vert, adjacents, n} = walk_edge(input, loc, prev_vert)
    edge = edge_key(prev_vert, vert)

    if MapSet.member?(walked, edge) do
      traverse(g, input, next, target, walked)
    else
      g =
        g
        |> put_in([Access.key(:edges), edge], n)
        |> update_in([Access.key(:verts), prev_vert], &update_verts(&1, vert))
        |> update_in([Access.key(:verts), vert], &update_verts(&1, prev_vert))

      new_next = Enum.map(adjacents, &{&1, vert})
      walked = MapSet.put(walked, edge)

      traverse(g, input, next ++ new_next, target, walked)
    end
  end

  defp walk_edge(input, tile, prev, n \\ 0) do
    case adjacent(input, tile, prev) do
      [next] ->
        walk_edge(input, next, tile, n + 1)

      list ->
        {tile, list, n + 1}
    end
  end

  defp adjacent(input, {col, row}, prev) do
    [
      {col + 1, row},
      {col - 1, row},
      {col, row + 1},
      {col, row - 1}
    ]
    |> Enum.reject(&(is_nil(input[&1]) or &1 == prev))
  end

  defp update_verts(nil, vert), do: [vert]
  defp update_verts(list, vert), do: [vert | list]

  defp edge_key(a, b), do: if(a <= b, do: {a, b}, else: {b, a})

  defp compact_graph(g, vert) do
    # Remove vert from verts and adjucent verts
    {[adj_vert], g} = pop_in(g, [Access.key(:verts), vert])
    g = update_in(g, [Access.key(:verts), adj_vert], &(&1 -- [vert]))

    # Remove original edge
    {edge_len, g} = pop_in(g, [Access.key(:edges), edge_key(vert, adj_vert)])

    # Add original edge length to adjacent edges
    g =
      g.edges
      |> Enum.filter(fn {{a, b}, _length} -> a == adj_vert or b == adj_vert end)
      |> Enum.reduce(g, fn {key, len}, acc ->
        put_in(acc, [Access.key(:edges), key], len + edge_len)
      end)

    {adj_vert, g}
  end
end

defmodule AdventOfCode.ReallyLongWalk do
  @moduledoc """
  # Day 23

  ## Part 2

  As you reach the trailhead, you realize that the ground isn't as slippery as you expected;
  you'll have no problem climbing up the steep slopes.

  Now, treat all slopes as if they were normal paths (.). You still want to make sure you have
  the most scenic hike possible, so continue to ensure that you never step onto the same tile
  twice. What is the longest hike you can take?

  In the example above, this increases the longest hike to 154 steps:

      #S#####################
      #OOOOOOO#########OOO###
      #######O#########O#O###
      ###OOOOO#.>OOO###O#O###
      ###O#####.#O#O###O#O###
      ###O>...#.#O#OOOOO#OOO#
      ###O###.#.#O#########O#
      ###OOO#.#.#OOOOOOO#OOO#
      #####O#.#.#######O#O###
      #OOOOO#.#.#OOOOOOO#OOO#
      #O#####.#.#O#########O#
      #O#OOO#...#OOO###...>O#
      #O#O#O#######O###.###O#
      #OOO#O>.#...>O>.#.###O#
      #####O#.#.###O#.#.###O#
      #OOOOO#...#OOO#.#.#OOO#
      #O#########O###.#.#O###
      #OOO###OOO#OOO#...#O###
      ###O###O#O###O#####O###
      #OOO#OOO#O#OOO>.#.>O###
      #O###O###O#O###.#.#O###
      #OOOOO###OOO###...#OOO#
      #####################O#

  Find the longest hike you can take through the surprisingly dry hiking trails listed on your
  map. How many steps long is the longest hike?
  """

  alias AdventOfCode.ReallyLongWalk.Graph

  @doc "Returns the number of steps of the longest hike disregarding slopes"
  def answer(input) do
    {{_max_x, max_y}, map} = parse(input)
    start = get_exit(map, 0)
    target = get_exit(map, max_y)
    graph = Graph.build(map, start, target)
    longest_concurent_walk(graph)
  end

  defp longest_concurent_walk(g) do
    [a, b] = g.verts[g.start]
    [a1, a2] = g.verts[a] -- [g.start]
    [b1, b2] = g.verts[b] -- [g.start]

    visited_a = MapSet.new([g.start, a])
    visited_b = MapSet.new([g.start, b])

    length_a = Graph.get_edge_length(g, {g.start, a})
    length_b = Graph.get_edge_length(g, {g.start, b})
    length_a1 = length_a + Graph.get_edge_length(g, {a, a1})
    length_a2 = length_a + Graph.get_edge_length(g, {a, a2})
    length_b1 = length_b + Graph.get_edge_length(g, {b, b1})
    length_b2 = length_b + Graph.get_edge_length(g, {b, b2})

    [
      {a1, visited_a, length_a1},
      {a2, visited_a, length_a2},
      {b1, visited_b, length_b1},
      {b2, visited_b, length_b2}
    ]
    |> Enum.map(fn start ->
      Task.async(fn ->
        longest_walk(g, [start], g.target, 0)
      end)
    end)
    |> Enum.map(&Task.await(&1, :infinity))
    |> Enum.max()
  end

  defp get_exit(map, target_row) do
    map
    |> Enum.find(fn {{_col, row}, _} -> row == target_row end)
    |> elem(0)
  end

  # ---- Traverse graph -------

  defp longest_walk(_g, [], _target, longest), do: longest

  defp longest_walk(g, [{target, _visited, n} | rest], target, longest) do
    longest_walk(g, rest, target, max(longest, n - 1))
  end

  defp longest_walk(g, [{vert, visited, n} | rest], target, longest) do
    visited = MapSet.put(visited, vert)

    next =
      Enum.reduce(g.verts[vert], rest, fn next_vert, acc ->
        if MapSet.member?(visited, next_vert) do
          acc
        else
          [{next_vert, visited, n + Graph.get_edge_length(g, {vert, next_vert})} | acc]
        end
      end)

    longest_walk(g, next, target, longest)
  end

  # ---- Parser --------

  defp parse(input, loc \\ {0, 0}, acc \\ %{})
  defp parse("\n", loc, acc), do: {loc, acc}
  defp parse("\n" <> rest, {_col, row}, acc), do: parse(rest, {0, row + 1}, acc)
  defp parse("#" <> rest, {col, row}, acc), do: parse(rest, {col + 1, row}, acc)

  defp parse(<<tile::utf8, rest::binary>>, {col, row} = loc, acc)
       when tile in [?., ?<, ?>, ?v, ?^],
       do: parse(rest, {col + 1, row}, Map.put(acc, loc, []))
end
