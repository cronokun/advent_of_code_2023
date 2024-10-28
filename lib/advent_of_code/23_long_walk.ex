defmodule AdventOfCode.LongWalk do
  @moduledoc """
  --- Day 23: A Long Walk ---

  The Elves resume water filtering operations! Clean water starts flowing over the edge of
  Island Island.

  They offer to help you go over the edge of Island Island, too! Just hold on tight to one end of
  this impossibly long rope and they'll lower you down a safe distance from the massive waterfall
  you just created.

  As you finally reach Snow Island, you see that the water isn't really reaching the ground: it's
  being absorbed by the air itself. It looks like you'll finally have a little downtime while the moisture builds up to snow-producing levels. Snow Island is pretty scenic, even without any snow; why not take a walk?

  There's a map of nearby hiking trails (your puzzle input) that indicates paths (.), forest (#),
  and steep slopes (^, >, v, and <).

  For example:

      #.#####################
      #.......#########...###
      #######.#########.#.###
      ###.....#.>.>.###.#.###
      ###v#####.#v#.###.#.###
      ###.>...#.#.#.....#...#
      ###v###.#.#.#########.#
      ###...#.#.#.......#...#
      #####.#.#.#######.#.###
      #.....#.#.#.......#...#
      #.#####.#.#.#########v#
      #.#...#...#...###...>.#
      #.#.#v#######v###.###v#
      #...#.>.#...>.>.#.###.#
      #####v#.#.###v#.#.###.#
      #.....#...#...#.#.#...#
      #.#########.###.#.#.###
      #...###...#...#...#.###
      ###.###.#.###v#####v###
      #...#...#.#.>.>.#.>.###
      #.###.###.#.###.#.#v###
      #.....###...###...#...#
      #####################.#

  You're currently on the single path tile in the top row; your goal is to reach the single path
  tile in the bottom row. Because of all the mist from the waterfall, the slopes are probably
  quite icy; if you step onto a slope tile, your next step must be downhill (in the direction the
  arrow is pointing). To make sure you have the most scenic hike possible, never step onto the
  same tile twice. What is the longest hike you can take?

  In the example above, the longest hike you can take is marked with O, and your starting position
  is marked S:

      #S#####################
      #OOOOOOO#########...###
      #######O#########.#.###
      ###OOOOO#OOO>.###.#.###
      ###O#####O#O#.###.#.###
      ###OOOOO#O#O#.....#...#
      ###v###O#O#O#########.#
      ###...#O#O#OOOOOOO#...#
      #####.#O#O#######O#.###
      #.....#O#O#OOOOOOO#...#
      #.#####O#O#O#########v#
      #.#...#OOO#OOO###OOOOO#
      #.#.#v#######O###O###O#
      #...#.>.#...>OOO#O###O#
      #####v#.#.###v#O#O###O#
      #.....#...#...#O#O#OOO#
      #.#########.###O#O#O###
      #...###...#...#OOO#O###
      ###.###.#.###v#####O###
      #...#...#.#.>.>.#.>O###
      #.###.###.#.###.#.#O###
      #.....###...###...#OOO#
      #####################O#

  This hike contains 94 steps. (The other possible hikes you could have taken were 90, 86, 82, 82,
  and 74 steps long.)

  Find the longest hike you can take through the hiking trails listed on your map. How many steps
  long is the longest hike?
  """

  @doc "Returns the number of steps of the longest hike."
  def answer(input) do
    {{_max_x, max_y}, map} = parse(input)
    start = get_exit(map, 0)
    target = get_exit(map, max_y)
    traverse(map, [{start, 0, MapSet.new()}], target, [])
  end

  defp get_exit(map, target_row) do
    Enum.find(map, fn
      {{_col, ^target_row}, :path} -> true
      _ -> false
    end)
  end

  # ---- Traverse --------

  defp traverse(_map, [], _target, acc), do: Enum.max(acc)

  defp traverse(map, [{{loc, :path}, steps, _visited} | queue], {loc, :path} = target, acc) do
    traverse(map, queue, target, [steps | acc])
  end

  defp traverse(map, [{{loc, type}, steps, visited} | queue], target, acc) do
    visited = MapSet.put(visited, loc)

    next =
      find_neighbours(map, {loc, type}, visited)
      |> tap(fn list ->
        list
        |> Enum.map(&elem(&1, 0))
      end)
      |> Enum.map(&{&1, steps + 1, visited})

    traverse(map, queue ++ next, target, acc)
  end

  @slops [:slop_left, :slop_right, :slop_up, :slop_down]

  defp find_neighbours(map, {{col, row}, type}, visited) when type in @slops do
    next_loc =
      case type do
        :slop_left -> {col - 1, row}
        :slop_right -> {col + 1, row}
        :slop_up -> {col, row - 1}
        :slop_down -> {col, row + 1}
      end

    next_type = Map.get(map, next_loc)

    if MapSet.member?(visited, next_loc) do
      []
    else
      [{next_loc, next_type}]
    end
  end

  defp find_neighbours(map, {{col, row}, :path}, visited) do
    [
      {col + 1, row},
      {col - 1, row},
      {col, row + 1},
      {col, row - 1}
    ]
    |> Enum.reject(&MapSet.member?(visited, &1))
    |> Enum.map(&{&1, Map.get(map, &1)})
    |> Enum.reject(fn
      {_loc, nil} -> true
      {_loc, :path} -> false
      {{slop_col, _}, :slop_left} -> slop_col > col
      {{slop_col, _}, :slop_right} -> slop_col < col
      {{_, slop_row}, :slop_up} -> slop_row > row
      {{_, slop_row}, :slop_down} -> slop_row < row
    end)
  end

  # ---- Parser --------

  defp parse(input, loc \\ {0, 0}, acc \\ %{})

  defp parse("\n", loc, acc), do: {loc, acc}
  defp parse("\n" <> rest, {_col, row}, acc), do: parse(rest, {0, row + 1}, acc)
  defp parse("#" <> rest, {col, row}, acc), do: parse(rest, {col + 1, row}, acc)

  defp parse("." <> rest, {col, row} = loc, acc),
    do: parse(rest, {col + 1, row}, Map.put(acc, loc, :path))

  defp parse(">" <> rest, {col, row} = loc, acc),
    do: parse(rest, {col + 1, row}, Map.put(acc, loc, :slop_right))

  defp parse("<" <> rest, {col, row} = loc, acc),
    do: parse(rest, {col + 1, row}, Map.put(acc, loc, :slop_left))

  defp parse("^" <> rest, {col, row} = loc, acc),
    do: parse(rest, {col + 1, row}, Map.put(acc, loc, :slop_up))

  defp parse("v" <> rest, {col, row} = loc, acc),
    do: parse(rest, {col + 1, row}, Map.put(acc, loc, :slop_down))
end
