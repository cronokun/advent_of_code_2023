defmodule AdventOfCode.HotSprings do
  @moduledoc ~S"""
  # Day 12: Hot Springs

  ## --- Part 1 ---

  You finally reach the hot springs! You can see steam rising from secluded areas
  attached to the primary, ornate building.

  As you turn to enter, the researcher stops you. "Wait - I thought you were looking
  for the hot springs, weren't you?" You indicate that this definitely looks like
  hot springs to you.

  "Oh, sorry, common mistake! This is actually the onsen! The hot springs are next door."

  You look in the direction the researcher is pointing and suddenly notice the massive
  metal helixes towering overhead. "This way!"

  It only takes you a few more steps to reach the main gate of the massive fenced-off
  area containing the springs. You go through the gate and into a small administrative
  building.

  "Hello! What brings you to the hot springs today? Sorry they're not very hot right
  now; we're having a lava shortage at the moment." You ask about the missing machine
  parts for Desert Island.

  "Oh, all of Gear Island is currently offline! Nothing is being manufactured at the
  moment, not until we get more lava to heat our forges. And our springs. The springs
  aren't very springy unless they're hot!"

  "Say, could you go up and see why the lava stopped flowing? The springs are too cold for
  normal operation, but we should be able to find one springy enough to launch you up there!"

  There's just one problem - many of the springs have fallen into disrepair, so they're
  not actually sure which springs would even be safe to use! Worse yet, their condition
  records of which springs are damaged (your puzzle input) are also damaged! You'll need
  to help them repair the damaged records.

  In the giant field just outside, the springs are arranged into rows. For each row,
  the condition records show every spring and whether it is operational (`.`) or
  damaged (`#`).  This is the part of the condition records that is itself damaged;
  for some springs, it is simply unknown (`?`) whether the spring is operational or damaged.

  However, the engineer that produced the condition records also duplicated some of this
  information in a different format! After the list of springs for a given row, the size
  of each contiguous group of damaged springs is listed in the order those groups appear
  in the row. This list always accounts for every damaged spring, and each number is the
  entire size of its contiguous group (that is, groups are always separated by at least
  one operational spring: `####` would always be 4, never 2,2).

  So, condition records with no unknown spring conditions might look like this:

      #.#.### 1,1,3
      .#...#....###. 1,1,3
      .#.###.#.###### 1,3,1,6
      ####.#...#... 4,1,1
      #....######..#####. 1,6,5
      .###.##....# 3,2,1

  However, the condition records are partially damaged; some of the springs' conditions
  are actually unknown (`?`). For example:

      ???.### 1,1,3
      .??..??...?##. 1,1,3
      ?#?#?#?#?#?#?#? 1,3,1,6
      ????.#...#... 4,1,1
      ????.######..#####. 1,6,5
      ?###???????? 3,2,1

  Equipped with this information, it is your job to figure out how many different
  arrangements of operational and broken springs fit the given criteria in each row.

  In the first line (`???.### 1,1,3`), there is exactly one way separate groups of one, one,
  and three broken springs (in that order) can appear in that row: the first three
  unknown springs must be broken, then operational, then broken (`#.#`), making the
  whole row `#.#.###`.

  The second line is more interesting: `.??..??...?##. 1,1,3` could be a total of four
  different arrangements. The last ? must always be broken (to satisfy the final
  contiguous group of three broken springs), and each `??` must hide exactly one of the
  two broken springs. (Neither `??` could be both broken springs or they would form
  a single contiguous group of two; if that were true, the numbers afterward would
  have been 2,3 instead.) Since each `??` can either be `#.` or `.#`, there are four
  possible arrangements of springs.

  The last line is actually consistent with ten different arrangements! Because the
  first number is 3, the first and second `?` must both be `.` (if either were `#`,
  the first number would have to be 4 or higher). However, the remaining run of unknown
  spring conditions have many different ways they could hold groups of two and one
  broken springs:

      ?###???????? 3,2,1
      .###.##.#...
      .###.##..#..
      .###.##...#.
      .###.##....#
      .###..##.#..
      .###..##..#.
      .###..##...#
      .###...##.#.
      .###...##..#
      .###....##.#

  In this example, the number of possible arrangements for each row is:

  - ???.### 1,1,3 - 1 arrangement
  - .??..??...?##. 1,1,3 - 4 arrangements
  - ?#?#?#?#?#?#?#? 1,3,1,6 - 1 arrangement
  - ????.#...#... 4,1,1 - 1 arrangement
  - ????.######..#####. 1,6,5 - 4 arrangements
  - ?###???????? 3,2,1 - 10 arrangements

  Adding all of the possible arrangement counts together produces a total of 21 arrangements.

  For each row, count all of the different arrangements of operational and broken
  springs that meet the given criteria. **What is the sum of those counts?**
  """

  @doc "Sum of all possible arrangements"
  def answer(input) do
    input
    |> parse_input()
    |> Enum.map(&calc_variants/1)
    |> Enum.sum()
  end

  defp calc_variants({line, stats, record}) do
    btotal = Enum.sum(record)
    br_rem = btotal - stats.broken
    bl_rem = stats.unknown - br_rem

    uniq_perms([], {"#", br_rem}, {".", bl_rem}, [])
    |> tap(fn list -> Enum.count(list) end)
    |> Enum.map(fn fills -> fill_line(line, fills) end)
    |> Enum.filter(fn line -> valid_line?(line, record) end)
    |> Enum.count()
  end

  # --- Uniq permutations ---

  defp uniq_perms(cur, {_a, 0}, {b, m}, acc) do
    r = Enum.reduce(1..m, cur, fn _i, acc -> [b | acc] end) |> Enum.reverse()
    Enum.reverse([r | acc])
  end

  defp uniq_perms(cur, {a, n}, {_b, 0}, acc) do
    r = Enum.reduce(1..n, cur, fn _i, acc -> [a | acc] end) |> Enum.reverse()
    Enum.reverse([r | acc])
  end

  defp uniq_perms(cur, {a, 1}, {b, 1}, acc) do
    v1 = [b, a | cur] |> Enum.reverse()
    v2 = [a, b | cur] |> Enum.reverse()
    Enum.reverse([v2, v1 | acc])
  end

  defp uniq_perms(cur, {a, n}, {b, m}, acc) do
    v1 = uniq_perms([a | cur], {a, n - 1}, {b, m}, acc)
    v2 = uniq_perms([b | cur], {a, n}, {b, m - 1}, acc)
    v1 ++ v2
  end

  # ------

  defp fill_line(line, fills) do
    Enum.reduce(fills, line, fn ch, l -> String.replace(l, "?", ch, global: false) end)
  end

  defp valid_line?(line, expected) do
    actual =
      line
      |> String.split(".", trim: true)
      |> Enum.map(&String.length/1)

    actual == expected
  end

  # --- Parser ---

  defp parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_line/1)
  end

  defp parse_line(line) do
    [a, b] = String.split(line, " ")
    {a, parse_map(a, %{blank: 0, broken: 0, unknown: 0}), parse_record(b)}
  end

  defp parse_map("", acc), do: Map.put(acc, :total, acc.blank + acc.broken + acc.unknown)
  defp parse_map("." <> rest, acc), do: parse_map(rest, Map.update!(acc, :blank, &(&1 + 1)))
  defp parse_map("#" <> rest, acc), do: parse_map(rest, Map.update!(acc, :broken, &(&1 + 1)))
  defp parse_map("?" <> rest, acc), do: parse_map(rest, Map.update!(acc, :unknown, &(&1 + 1)))

  defp parse_record(string) do
    string
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
  end
end
