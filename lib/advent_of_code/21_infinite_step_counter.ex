defmodule AdventOfCode.InfiniteStepCounter do
  @moduledoc """
  # Day 21: Step Counter

  ## Part Two

  The Elf seems confused by your answer until he realizes his mistake: he was reading from a list
  of his favorite numbers that are both perfect squares and perfect cubes, not his step counter.

  The actual number of steps he needs to get today is exactly **26501365**.

  He also points out that the garden plots and rocks are set up so that the map repeats infinitely
  in every direction.

  So, if you were to look one additional map-width or map-height out from the edge of the example
  map above, you would find that it keeps repeating:

    .................................
    .....###.#......###.#......###.#.
    .###.##..#..###.##..#..###.##..#.
    ..#.#...#....#.#...#....#.#...#..
    ....#.#........#.#........#.#....
    .##...####..##...####..##...####.
    .##..#...#..##..#...#..##..#...#.
    .......##.........##.........##..
    .##.#.####..##.#.####..##.#.####.
    .##..##.##..##..##.##..##..##.##.
    .................................
    .................................
    .....###.#......###.#......###.#.
    .###.##..#..###.##..#..###.##..#.
    ..#.#...#....#.#...#....#.#...#..
    ....#.#........#.#........#.#....
    .##...####..##..S####..##...####.
    .##..#...#..##..#...#..##..#...#.
    .......##.........##.........##..
    .##.#.####..##.#.####..##.#.####.
    .##..##.##..##..##.##..##..##.##.
    .................................
    .................................
    .....###.#......###.#......###.#.
    .###.##..#..###.##..#..###.##..#.
    ..#.#...#....#.#...#....#.#...#..
    ....#.#........#.#........#.#....
    .##...####..##...####..##...####.
    .##..#...#..##..#...#..##..#...#.
    .......##.........##.........##..
    .##.#.####..##.#.####..##.#.####.
    .##..##.##..##..##.##..##..##.##.
    .................................

  This is just a tiny three-map-by-three-map slice of the inexplicably-infinite farm layout;
  garden plots and rocks repeat as far as you can see. The Elf still starts on the one middle
  tile marked S, though - every other repeated S is replaced with a normal garden plot (.).

  Here are the number of reachable garden plots in this new infinite version of the example map
  for different numbers of steps:

  - In exactly 6 steps, he can still reach 16 garden plots.
  - In exactly 10 steps, he can reach any of 50 garden plots.
  - In exactly 50 steps, he can reach 1594 garden plots.
  - In exactly 100 steps, he can reach 6536 garden plots.
  - In exactly 500 steps, he can reach 167004 garden plots.
  - In exactly 1000 steps, he can reach 668697 garden plots.
  - In exactly 5000 steps, he can reach 16733044 garden plots.

  However, the step count the Elf needs is much larger! Starting from the garden plot marked S on
  your infinite map, how many garden plots could the Elf reach in exactly 26501365 steps?
  """

  @doc "How many garden plots could the Elf reach in exactly N steps on infinite map"
  def answer(input, n \\ 26_501_365, debug? \\ false) do
    {plots, start, size} = parse(input, 0, 0, nil, [])

    result = traverse([start], plots, size, n)

    if debug? do
      print_grid(plots, result, size, n)
      grid_nums(result, n, size)
    end

    length(result)
  end

  defp traverse(starts, plots, size, n, next \\ MapSet.new())

  defp traverse(starts, _plots, _size, 0, _next), do: starts

  defp traverse([], plots, size, n, next) do
    traverse(MapSet.to_list(next), plots, size, n - 1, MapSet.new())
  end

  defp traverse([loc | rest], plots, size, n, next) do
    neighbours = find_neighbours(loc, size, plots)
    next = MapSet.union(next, MapSet.new(neighbours))
    traverse(rest, plots, size, n, next)
  end

  defp find_neighbours({x, y}, size, plots) do
    [{x + 1, y}, {x - 1, y}, {x, y + 1}, {x, y - 1}]
    |> Enum.filter(fn {nx, ny} ->
      mod_x = mod_rem(nx, size)
      mod_y = mod_rem(ny, size)
      MapSet.member?(plots, {mod_x, mod_y})
    end)
  end

  defp mod_rem(n, size) do
    case rem(n, size) do
      0 -> 0
      r when r < 0 -> r + size
      r -> r
    end
  end

  defp parse("\n", size, _, start, acc), do: {MapSet.new(acc), start, size}
  defp parse("\n" <> input, _x, y, start, acc), do: parse(input, 0, y + 1, start, acc)
  defp parse("S" <> input, x, y, nil, acc), do: parse(input, x + 1, y, {x, y}, [{x, y} | acc])
  defp parse("#" <> input, x, y, start, acc), do: parse(input, x + 1, y, start, acc)
  defp parse("." <> input, x, y, start, acc), do: parse(input, x + 1, y, start, [{x, y} | acc])

  # ---- Debug --------------------

  defp print_grid(plots, visited, size, n) do
    IO.puts("\n#{length(visited)} plots visited after #{n} steps:\n")

    for y <- 0..(size - 1) do
      for x <- 0..(size - 1) do
        if {x, y} in plots do
          if {x, y} in visited, do: IO.write("◼︎ "), else: IO.write(". ")
        else
          IO.write("# ")
        end
      end

      IO.write("\n")
    end

    IO.write("\n")
  end

  defp grid_nums(visited, steps, size) do
    s = steps - div(size, 2)
    k = div(s, size) + 1
    d = size * k

    numbers =
      visited
      |> Enum.sort()
      |> Enum.map(fn {x, y} -> {x + d, y + d} end)
      |> Enum.group_by(fn {x, y} -> {div(x, size), div(y, size)} end)
      |> Enum.reduce(%{}, fn {cc, ll}, acc -> Map.put(acc, cc, length(ll)) end)

    n = div(s, size) * 2 + 2

    for y <- 0..n do
      for x <- 0..n do
        case Map.fetch(numbers, {x, y}) do
          {:ok, num} -> IO.write(String.pad_trailing("#{num}", 8))
          :error -> IO.write(String.pad_trailing("-", 8))
        end
      end

      IO.write("\n")
    end

    IO.write("\n")
  end


  @doc "How many garden plots could the Elf reach in exactly N steps on infinite map (math)"
  def math_answer(input, n \\ 26_501_365) do
    {_, _, size} = parse(input, 0, 0, nil, [])

    # Here is result of `.answer(input, 131 * 2 + 65)`. From it we can derive solution to larger step numbers:
    #
    #                    946   5456  921
    #              946   6342  7334  6364  921
    #        946   6342  7334  7250  7334  6364  921
    #  946   6342  7334  7250  7334  7250  7334  6364  921
    #  5480  7334  7250  7334  7250  7334  7250  7334  5473
    #  924   6388  7334  7250  7334  7250  7334  6359  926
    #        924   6388  7334  7250  7334  6359  926
    #              924   6388  7334  6359  926
    #                    924   5497  926

    k = div(n - div(size, 2), size)
    t = 2 * k * k - (2 * k - 1)
    m1 = (k - 1) * k - (k - 1)
    m2 = t - m1

    5480 + 5456 + 5473 + 5497 +
      (946 + 924 + 921 + 926) * k +
      (6342 + 6364 + 6388 + 6359) * (k - 1) +
      7250 * m1 + 7334 * m2
  end
end
