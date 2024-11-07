defmodule AdventOfCode.PointOfIncidence do
  @moduledoc """
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

  ## --- Part 2 ----

  You resume walking through the valley of mirrors and - SMACK! - run directly into one.
  Hopefully nobody was watching, because that must have been pretty embarrassing.

  Upon closer inspection, you discover that every mirror has exactly one smudge: exactly
  one `.` or `#` should be the opposite type.

  In each pattern, you'll need to locate and fix the smudge that causes a different
  reflection line to be valid. (The old reflection line won't necessarily continue
  being valid after the smudge is fixed.)

  Here's the above example again:

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

  The first pattern's smudge is in the top-left corner. If the top-left `#` were instead `.`,
  it would have a different, horizontal line of reflection:

      1 ..##..##. 1
      2 ..#.##.#. 2
      3v##......#v3
      4^##......#^4
      5 ..#.##.#. 5
      6 ..##..##. 6
      7 #.#.##.#. 7

  With the smudge in the top-left corner repaired, a new horizontal line of reflection
  between rows 3 and 4 now exists. Row 7 has no corresponding reflected row and can be
  ignored, but every other row matches exactly: row 1 matches row 6, row 2 matches row 5,
  and row 3 matches row 4.

  In the second pattern, the smudge can be fixed by changing the fifth symbol on row 2
  from `.` to `#`:

      1v#...##..#v1
      2^#...##..#^2
      3 ..##..### 3
      4 #####.##. 4
      5 #####.##. 5
      6 ..##..### 6
      7 #....#..# 7

  Now, the pattern has a different horizontal line of reflection between rows 1 and 2.

  Summarize your notes as before, but instead use the new different reflection lines.
  In this example, the first pattern's new horizontal line has 3 rows above it and the
  second pattern's new horizontal line has 1 row above it, summarizing to the value 400.

  In each pattern, fix the smudge and find the different line of reflection. **What number
  do you get after summarizing the new reflection line in each pattern in your notes?**
  """

  @doc "Find mirrors"
  def answer(input) do
    input
    |> parse_input()
    |> Enum.reduce(0, fn block, sum -> sum + process_block(block) end)
  end

  defp process_block(block) do
    case find_mirror(block) do
      {:horizontal, idx} -> idx
      {:vertical, idx} -> idx * 100
    end
  end

  @doc "Find mirrors and fix smudges"
  def final_answer(input) do
    input
    |> parse_input()
    |> Enum.reduce(0, fn block, sum -> sum + fix_and_process_block(block) end)
  end

  defp fix_and_process_block(block) do
    original_mirror = find_mirror(block)

    block
    |> all_smudges()
    |> Enum.reduce_while(0, fn fixed_block, _ ->
      case find_mirror(fixed_block, original_mirror) do
        nil -> {:cont, nil}
        res -> {:halt, res}
      end
    end)
    |> case do
      {:horizontal, idx} -> idx
      {:vertical, idx} -> idx * 100
    end
  end

  defp all_smudges(list), do: all_smudges(Enum.join(list, "\n"), "", [])

  defp all_smudges("", _pref, acc),
    do: acc |> Enum.reverse(acc) |> Enum.map(&String.split(&1, "\n"))

  defp all_smudges(<<"0", rest::binary>>, pref, acc),
    do: all_smudges(rest, pref <> "0", [pref <> "1" <> rest | acc])

  defp all_smudges(<<"1", rest::binary>>, pref, acc),
    do: all_smudges(rest, pref <> "1", [pref <> "0" <> rest | acc])

  defp all_smudges(<<"\n", rest::binary>>, pref, acc), do: all_smudges(rest, pref <> "\n", acc)

  # --- Find mirror ---

  defp find_mirror(lines, original \\ :nope) do
    mirror_index(flip(lines), :horizontal, original) || mirror_index(lines, :vertical, original)
  end

  defp mirror_index(lines, mode, original) do
    data = prepare_input(lines)

    data
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.find(fn [{i, a}, {_, b}] ->
      a == b and {mode, i} != original and mirror?(data, i)
    end)
    |> case do
      nil -> nil
      [{idx, _}, _] -> {mode, idx}
    end
  end

  defp mirror?(data, idx), do: mirror?(data, Enum.count(data), {idx, idx + 1}, nil)
  defp mirror?(_data, _len, _idxs, false), do: false

  defp mirror?(data, len, {a, b}, _acc) when a >= 1 and b <= len,
    do: mirror?(data, len, {a - 1, b + 1}, data[a] == data[b])

  defp mirror?(_data, _len, _idxs, acc), do: acc

  # --- Parser & Utils ---

  defp parse_input(input) do
    input
    |> String.split("\n\n", trim: true)
    |> Enum.map(
      &(String.replace(&1, ["#", "."], fn
          "#" -> "1"
          "." -> "0"
        end)
        |> String.split("\n", trim: true))
    )
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
