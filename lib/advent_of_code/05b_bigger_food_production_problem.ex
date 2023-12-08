defmodule AdventOfCode.BiggerFoodProductionProblem do
  @moduledoc ~S"""
  # Day 5: If You Give A Seed A Fertilizer

  ## Part 2

  Everyone will starve if you only plant such a small number of seeds. Re-reading
  the almanac, it looks like the seeds: line actually describes ranges of seed numbers.

  The values on the initial seeds: line come in pairs. Within each pair, the first
  value is the start of the range and the second value is the length of the range.
  So, in the first line of the example above:

        seeds: 79 14 55 13

  This line describes two ranges of seed numbers to be planted in the garden. The first
  range starts with seed number 79 and contains 14 values: 79, 80, ..., 91, 92.
  The second range starts with seed number 55 and contains 13 values: 55, 56, ..., 66, 67.

  Now, rather than considering four seed numbers, you need to consider a total of 27 seed numbers.

  In the above example, the lowest location number can be obtained from seed number 82,
  which corresponds to soil 84, fertilizer 84, water 84, light 77, temperature 45,
  humidity 46, and location 46. So, the lowest location number is 46.

  Consider all of the initial seed numbers listed in the ranges on the first line
  of the almanac. **What is the lowest location number that corresponds to any of
  the initial seed numbers**?
  """

  @doc "Lowest location number"
  def answer(input) do
    {seeds, maps} = parse_input(input)

    seeds
    |> Enum.map(&process_all_maps([&1], maps))
    |> List.flatten()
    |> get_min_value()
  end

  defp process_all_maps(rs, []), do: rs

  defp process_all_maps(rs, [map | rest]) do
    next = process_a_map(rs, map, [])
    process_all_maps(next, rest)
  end

  defp process_a_map(rs, [], acc), do: rs ++ acc

  defp process_a_map(rs, [entry | rest], acc) do
    {matches, next} =
      rs
      |> Enum.map(fn r -> process_range_entry(r, entry) end)
      |> List.flatten()
      |> Enum.split_with(fn {type, _} -> type == :halt end)

    next = next |> Enum.map(&elem(&1, 1))
    matches = matches |> Enum.map(&elem(&1, 1))
    process_a_map(next, rest, acc ++ matches)
  end

  defp process_range_entry(r, {s, d}) do
    split_range(r, s)
    |> Enum.map(fn
      {:cont, a} -> {:cont, a}
      {:halt, a} -> {:halt, map_source_to_dest(a, s, d)}
    end)
  end

  defp map_source_to_dest({r1, r2}, {s1, _s2}, {d1, _d2}) do
    diff = d1 - s1
    {r1 + diff, r2 + diff}
  end

  defp get_min_value(list), do: list |> Enum.sort() |> hd() |> elem(0)

  # ---- Parser -------

  defp parse_input(input) do
    [seeds_str | map_blocks] = String.split(input, "\n\n", trim: true)
    seeds = parse_seeds(seeds_str)
    maps = Enum.map(map_blocks, &parse_map/1)
    {seeds, maps}
  end

  defp parse_seeds(<<"seeds: ", seeds::binary>>) do
    seeds
    |> string_to_numbers()
    |> Enum.chunk_every(2)
    |> Enum.map(fn [a, b] -> make_range_tuple(a, b) end)
  end

  defp parse_map(map) when is_binary(map) do
    map
    |> String.split("\n", trim: true)
    |> tl()
    |> Enum.map(fn str ->
      [dest, source, range] = string_to_numbers(str)
      {make_range_tuple(source, range), make_range_tuple(dest, range)}
    end)
  end

  defp string_to_numbers(str) when is_binary(str) do
    str
    |> String.split(" ", trim: true)
    |> Enum.map(fn n ->
      {num, ""} = Integer.parse(n)
      num
    end)
  end

  # ---- Utils --------

  defp split_range({a1, a2} = a, {b1, b2} = b) do
    cond do
      a2 < b1 or b2 < a1 -> [{:cont, a}]
      a1 >= b1 and a2 <= b2 -> [{:halt, a}]
      a1 < b1 and a2 > b2 -> [{:cont, {a1, b1 - 1}}, {:halt, {b1, b2}}, {:cont, {b2 + 1, a2}}]
      a1 < b1 and a2 <= b2 -> [{:cont, {a1, b1 - 1}}, {:halt, {b1, a2}}]
      a1 >= b1 and a1 < b2 -> [{:halt, {a1, b2}}, {:cont, {b2 + 1, a2}}]
      true -> {:error, {a, b}}
    end
  end

  defp make_range_tuple(a, b), do: {a, a + b - 1}
end
