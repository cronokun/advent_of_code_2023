defmodule AdventOfCode.PointOfIncidence do
  @moduledoc ~S"""
  # Day 13: Point of Incidence

  ## --- Part 1 ----

  With your help, the hot springs team locates an appropriate spring which launches
  you neatly and precisely up to the edge of Lava Island.

  There's just one problem: you don't see any lava.

  You do see a lot of ash and igneous rock; there are even what look like gray mountains
  scattered around. After a while, you make your way to a nearby cluster of mountains
  only to discover that the valley between them is completely full of large mirrors.
  Most of the mirrors seem to be aligned in a consistent way; perhaps you should
  head in that direction?

  As you move through the valley of mirrors, you find that several of them have fallen
  from the large metal frames keeping them in place. The mirrors are extremely flat
  and shiny, and many of the fallen mirrors have lodged into the ash at strange angles.
  Because the terrain is all one color, it's hard to tell where it's safe to walk
  or where you're about to run into a mirror.

  You note down the patterns of ash (.) and rocks (#) that you see as you walk
  (your puzzle input); perhaps by carefully analyzing these patterns, you can
  figure out where the mirrors are!

  For example:

      #.##..##.
      ..#.##.#.
      ##......#
      ##......#
      ..#.##.#.
      ..##..##.
      #.#.##.#.

      #...##..#
      #....#..#
      ..##..###
      #####.##.
      #####.##.
      ..##..###
      #....#..#

  To find the reflection in each pattern, you need to find a perfect reflection across
  either a horizontal line between two rows or across a vertical line between two columns.

  In the first pattern, the reflection is across a vertical line between two columns;
  arrows on each of the two columns point at the line between the columns:

      123456789
          ><   
      #.##..##.
      ..#.##.#.
      ##......#
      ##......#
      ..#.##.#.
      ..##..##.
      #.#.##.#.
          ><   
      123456789

  In this pattern, the line of reflection is the vertical line between columns 5 and 6.
  Because the vertical line is not perfectly in the middle of the pattern, part of the
  pattern (column 1) has nowhere to reflect onto and can be ignored; every other column
  has a reflected column within the pattern and must match exactly: column 2 matches
  column 9, column 3 matches 8, 4 matches 7, and 5 matches 6.

  The second pattern reflects across a horizontal line instead:

      1 #...##..# 1
      2 #....#..# 2
      3 ..##..### 3
      4v#####.##.v4
      5^#####.##.^5
      6 ..##..### 6
      7 #....#..# 7

  This pattern reflects across the horizontal line between rows 4 and 5. Row 1 would
  reflect with a hypothetical row 8, but since that's not in the pattern, row 1 doesn't
  need to match anything. The remaining rows match: row 2 matches row 7, row 3 matches
  row 6, and row 4 matches row 5.

  To summarize your pattern notes, add up the number of columns to the left of each
  vertical line of reflection; to that, also add 100 multiplied by the number of rows
  above each horizontal line of reflection. In the above example, the first pattern's
  vertical line has 5 columns to its left and the second pattern's horizontal line
  has 4 rows above it, a total of 405.

  Find the line of reflection in each of the patterns in your notes. **What number
  do you get after summarizing all of your notes?**
  """

  def answer(input) do
    input
    |> String.split("\n\n", trim: true)
    |> Enum.reduce(0, fn block, sum ->
      case block |> parse_input() |> find_mirror() do
        {:horizontal, idx} -> sum + idx
        {:vertical, idx} -> sum + idx * 100
      end
    end)
  end

  def find_mirror(lines) do
    mirror_index(flip(lines), :horizontal) || mirror_index(lines, :vertical)
  end

  def mirror_index(lines, mode) do
    data = prepare_input(lines)

    data
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.find(fn [{i, a}, {_, b}] -> a == b and is_mirror?(data, i) end)
    |> case do
      nil -> nil
      [{idx, _}, _] -> {mode, idx}
    end
  end

  defp is_mirror?(data, idx), do: is_mirror?(data, Enum.count(data), {idx, idx + 1}, nil)
  defp is_mirror?(_data, _len, _idxs, false), do: false

  defp is_mirror?(data, len, {a, b}, _acc) when a >= 1 and b <= len do
    is_mirror?(data, len, {a - 1, b + 1}, data[a] == data[b])
  end

  defp is_mirror?(_data, _len, _idxs, acc), do: acc

  # --- Parser & Utils ---

  defp parse_input(input) do
    input
    |> String.replace(["#", "."], fn
      "#" -> "1"
      "." -> "0"
    end)
    |> String.split("\n", trim: true)
  end

  defp flip(lines) do
    lines
    |> Enum.map(&String.graphemes/1)
    |> Enum.zip()
    |> Enum.map(&(&1 |> Tuple.to_list() |> Enum.join()))
  end

  defp prepare_input(block, acc \\ [], lnum \\ 1)
  defp prepare_input([], acc, _lnum), do: Map.new(acc)

  defp prepare_input([line | rest], acc, lnum) do
    prepare_input(rest, [{lnum, String.to_integer(line, 2)} | acc], lnum + 1)
  end
end
