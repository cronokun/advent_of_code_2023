defmodule AdventOfCode.CosmicExpansion do
  @moduledoc ~S"""
  # Day 11: Cosmic Expansion

  ## Part 1

  You continue following signs for "Hot Springs" and eventually come across an
  observatory. The Elf within turns out to be a researcher studying cosmic expansion
  using the giant telescope here.

  He doesn't know anything about the missing machine parts; he's only visiting for
  this research project. However, he confirms that the hot springs are the next-closest
  area likely to have people; he'll even take you straight there once he's done with
  today's observation analysis.

  Maybe you can help him with the analysis to speed things up?

  The researcher has collected a bunch of data and compiled the data into a single
  giant image (your puzzle input). The image includes empty space (.) and galaxies (#).
  For example:

      ...#......
      .......#..
      #.........
      ..........
      ......#...
      .#........
      .........#
      ..........
      .......#..
      #...#.....

  The researcher is trying to figure out the sum of the lengths of the shortest path
  between every pair of galaxies. However, there's a catch: the universe expanded
  in the time it took the light from those galaxies to reach the observatory.

  Due to something involving gravitational effects, only some space expands. In fact,
  the result is that any rows or columns that contain no galaxies should all actually
  be twice as big.

  In the above example, three columns and two rows contain no galaxies:

         v  v  v
       ...#......
       .......#..
       #.........
      >..........<
       ......#...
       .#........
       .........#
      >..........<
       .......#..
       #...#.....
         ^  ^  ^

  These rows and columns need to be twice as big; the result of cosmic expansion
  therefore looks like this:

      ....#........
      .........#...
      #............
      .............
      .............
      ........#....
      .#...........
      ............#
      .............
      .............
      .........#...
      #....#.......

  Equipped with this expanded universe, the shortest path between every pair of galaxies
  can be found. It can help to assign every galaxy a unique number:

      ....1........
      .........2...
      3............
      .............
      .............
      ........4....
      .5...........
      ............6
      .............
      .............
      .........7...
      8....9.......

  In these 9 galaxies, there are 36 pairs. Only count each pair once; order within
  the pair doesn't matter. For each pair, find any shortest path between the two
  galaxies using only steps that move up, down, left, or right exactly one . or # at a time.
  (The shortest path between two galaxies is allowed to pass through another galaxy.)

  For example, here is one of the shortest paths between galaxies 5 and 9:

      ....1........
      .........2...
      3............
      .............
      .............
      ........4....
      .5...........
      .##.........6
      ..##.........
      ...##........
      ....##...7...
      8....9.......

  This path has length 9 because it takes a minimum of nine steps to get from galaxy 5
  to galaxy 9 (the eight locations marked # plus the step onto galaxy 9 itself). Here
  are some other example shortest path lengths:

  - Between galaxy 1 and galaxy 7: 15
  - Between galaxy 3 and galaxy 6: 17
  - Between galaxy 8 and galaxy 9: 5

  In this example, after expanding the universe, the sum of the shortest path between
  all 36 pairs of galaxies is 374.

  Expand the universe, then find the length of the shortest path between every pair
  of galaxies. What is the sum of these lengths?
  """

  @doc "Sum of shortest paths between every pair of galaxies"
  def answer(input) do
    input
    |> apply_cosmic_expansion()
    |> find_all_galaxies()
    |> all_pairs()
    |> calc_paths_sum()
  end

  defp find_all_galaxies(lines) do
    lines
    |> Enum.with_index()
    |> Enum.flat_map(fn {line, y} ->
      line
      |> get_galaxies_on_line()
      |> Enum.map(fn x -> {x, y} end)
    end)
    |> Enum.reject(&(&1 == []))
  end

  defp calc_paths_sum(pairs) do
    pairs
    |> Enum.map(&calc_shortest_path/1)
    |> Enum.sum()
  end

  defp all_pairs(list), do: all_pairs(list, 2)
  defp all_pairs(_, 0), do: [[]]
  defp all_pairs([], _), do: []

  defp all_pairs([h | t], m) do
    for(l <- all_pairs(t, m - 1), do: [h | l]) ++ all_pairs(t, m)
  end

  defp calc_shortest_path([{x1, y1}, {x2, y2}]), do: abs(x1 - x2) + abs(y1 - y2)

  # ---- Cosmix expanse ----

  defp apply_cosmic_expansion(image) do
    image
    |> expand_rows()
    |> expand_columns()
  end

  def expand_rows(image) do
    image
    |> String.split("\n", trim: true)
    |> Enum.reduce([], fn line, acc ->
      if String.contains?(line, "#") do
        [line | acc]
      else
        [line | [line | acc]]
      end
    end)
    |> Enum.reverse()
  end

  defp expand_columns(lines) do
    empty_columns = get_empty_columns(lines)
    Enum.map(lines, fn line -> expand_empty_columns(line, 0, empty_columns, "") end)
  end

  defp expand_empty_columns("", _, _, acc), do: acc

  defp expand_empty_columns("." <> rest, i, ixs, acc) do
    char = if i in ixs, do: "..", else: "."
    expand_empty_columns(rest, i + 1, ixs, acc <> char)
  end

  defp expand_empty_columns("#" <> rest, i, ixs, acc) do
    expand_empty_columns(rest, i + 1, ixs, acc <> "#")
  end

  defp get_empty_columns(lines) do
    len = lines |> hd() |> String.length()
    indexes = Range.new(0, len - 1) |> Range.to_list()
    galaxy_indexes = Enum.flat_map(lines, &get_galaxies_on_line/1)
    indexes -- galaxy_indexes
  end

  defp get_galaxies_on_line(line) do
    Regex.scan(~r/#/, line, return: :index) |> Enum.map(fn [{i, _}] -> i end)
  end
end
