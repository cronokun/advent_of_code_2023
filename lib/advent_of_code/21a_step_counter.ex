defmodule AdventOfCode.StepCounter do
  @moduledoc """
  # Day 21: Step Counter

  ## Part 1

  You manage to catch the airship right as it's dropping someone else off on their
  all-expenses-paid trip to Desert Island! It even helpfully drops you off near the gardener
  and his massive farm.

  "You got the sand flowing again! Great work! Now we just need to wait until we have enough sand
  to filter the water for Snow Island and we'll have snow again in no time."

  While you wait, one of the Elves that works with the gardener heard how good you are at solving
  problems and would like your help. He needs to get his steps in for the day, and so he'd like
  to know which garden plots he can reach with exactly his remaining 64 steps.

  He gives you an up-to-date map (your puzzle input) of his starting position (S), garden plots
  (.), and rocks (#). For example:

    ...........
    .....###.#.
    .###.##..#.
    ..#.#...#..
    ....#.#....
    .##..S####.
    .##..#...#.
    .......##..
    .##.#.####.
    .##..##.##.
    ...........

  The Elf starts at the starting position (S) which also counts as a garden plot. Then, he can
  take one step north, south, east, or west, but only onto tiles that are garden plots. This
  would allow him to reach any of the tiles marked O:

    ...........
    .....###.#.
    .###.##..#.
    ..#.#...#..
    ....#O#....
    .##.OS####.
    .##..#...#.
    .......##..
    .##.#.####.
    .##..##.##.
    ...........

  Then, he takes a second step. Since at this point he could be at either tile marked O, his
  second step would allow him to reach any garden plot that is one step north, south, east, or
  west of any tile that he could have reached after the first step:

    ...........
    .....###.#.
    .###.##..#.
    ..#.#O..#..
    ....#.#....
    .##O.O####.
    .##.O#...#.
    .......##..
    .##.#.####.
    .##..##.##.
    ...........

  After two steps, he could be at any of the tiles marked O above, including the starting
  position (either by going north-then-south or by going west-then-east).

  A single third step leads to even more possibilities:

    ...........
    .....###.#.
    .###.##..#.
    ..#.#.O.#..
    ...O#O#....
    .##.OS####.
    .##O.#...#.
    ....O..##..
    .##.#.####.
    .##..##.##.
    ...........

  He will continue like this until his steps for the day have been exhausted. After a total of
  6 steps, he could reach any of the garden plots marked O:

    ...........
    .....###.#.
    .###.##.O#.
    .O#O#O.O#..
    O.O.#.#.O..
    .##O.O####.
    .##.O#O..#.
    .O.O.O.##..
    .##.#.####.
    .##O.##.##.
    ...........

  In this example, if the Elf's goal was to get exactly 6 more steps today, he could use them to
  reach any of 16 garden plots.

  However, the Elf actually needs to get 64 steps today, and the map he's handed you is much
  larger than the example map.

  Starting from the garden plot marked S on your map, how many garden plots could the Elf reach
  in exactly 64 steps?
  """

  @doc "How many garden plots could the Elf reach in exactly N steps"
  def answer(input, n \\ 64) do
    {plots, start, max} = parse(input, 0, 0, nil, [])
    traverse([start], plots, max, n, MapSet.new())
  end

  defp traverse(starts, _plots, _max, 0, _next), do: length(starts)

  defp traverse([], plots, max, n, next) do
    traverse(MapSet.to_list(next), plots, max, n - 1, MapSet.new())
  end

  defp traverse([loc | rest], plots, max, n, next) do
    neighbours = find_neighbours(loc, max, plots) |> MapSet.new()
    traverse(rest, plots, max, n, MapSet.union(next, neighbours))
  end

  defp find_neighbours({x, y}, {mx, my}, plots) do
    Enum.filter([{x + 1, y}, {x - 1, y}, {x, y + 1}, {x, y - 1}], fn {nx, ny} ->
      nx >= 0 and nx <= mx and ny >= 0 and ny <= my and MapSet.member?(plots, {nx, ny})
    end)
  end

  defp parse("\n", x, y, start, acc), do: {MapSet.new(acc), start, {x - 1, y}}
  defp parse("\n" <> input, _x, y, start, acc), do: parse(input, 0, y + 1, start, acc)
  defp parse("S" <> input, x, y, nil, acc), do: parse(input, x + 1, y, {x, y}, [{x, y} | acc])
  defp parse("#" <> input, x, y, start, acc), do: parse(input, x + 1, y, start, acc)
  defp parse("." <> input, x, y, start, acc), do: parse(input, x + 1, y, start, [{x, y} | acc])
end
