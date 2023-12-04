defmodule AdventOfCode.GearRatios do
  @moduledoc ~S"""
  # Day 3

  ## Part 1

  You and the Elf eventually reach a gondola lift station; he says the gondola lift will
  take you up to the water source, but this is as far as he can bring you. You go inside.

  It doesn't take long to find the gondolas, but there seems to be a problem: they're not moving.

  "Aaah!"

  You turn around to see a slightly-greasy Elf with a wrench and a look of surprise.
  "Sorry, I wasn't expecting anyone! The gondola lift isn't working right now;
  it'll still be a while before I can fix it." You offer to help.

  The engineer explains that an engine part seems to be missing from the engine,
  but nobody can figure out which one. If you can add up all the part numbers
  in the engine schematic, it should be easy to work out which part is missing.

  The engine schematic (your puzzle input) consists of a visual representation of
  the engine. There are lots of numbers and symbols you don't really understand, but
  apparently any number adjacent to a symbol, even diagonally, is a "part number" and
  should be included in your sum. (Periods (.) do not count as a symbol.)

  Here is an example engine schematic:

      467..114..
      ...*......
      ..35..633.
      ......#...
      617*......
      .....+.58.
      ..592.....
      ......755.
      ...$.*....
      .664.598..

  In this schematic, two numbers are not part numbers because they are not adjacent to a
  symbol: 114 (top right) and 58 (middle right). Every other number is adjacent to a
  symbol and so is a part number; their sum is 4361.

  Of course, the actual engine schematic is much larger. **What is the sum of all
  of the part numbers in the engine schematic**?
  """

  defguardp is_adjusent(l, r, idx) when idx in l..r or idx + 1 == l or idx - 1 == r

  @doc "Sum of all of the part numbers"
  def answer(input) do
    with lines <- split_to_lines(input),
         numbers <- get_number_indexes(lines),
         symbols <- get_symbol_indexes(lines),
         part_numbers <- get_part_numbers(lines, numbers, symbols) do
      get_sum(part_numbers, 0)
    end
  end

  defp split_to_lines(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.reduce({%{}, 0}, fn line, {acc, num} -> {Map.put(acc, num, line), num + 1} end)
    |> elem(0)
  end

  defp get_number_indexes(lines) do
    for {num, line} <- lines, into: %{} do
      indexes =
        Regex.scan(~r/\d+/, line, return: :index)
        |> List.flatten()
        |> Enum.map(fn {i, len} -> i..(i + len - 1) end)

      {num, indexes}
    end
  end

  defp get_symbol_indexes(lines) do
    for {num, line} <- lines, into: %{} do
      indexes =
        Regex.scan(~r/[^.0-9]/, line, return: :index)
        |> List.flatten()
        |> Enum.map(fn {i, _len} -> i end)

      {num, indexes}
    end
  end

  defp get_part_numbers(lines, numbers, symbols) do
    for {num, indexes} <- symbols,
        n <- [num - 1, num, num + 1],
        range <- List.wrap(numbers[n]),
        idx <- indexes,
        uniq: true do
      return_part_number_for(lines[n], range, idx, n)
    end
    |> Enum.reject(&is_nil/1)
    |> Enum.map(&elem(&1, 0))
  end

  defp return_part_number_for(line, l..r = range, idx, n)
       when is_adjusent(l, r, idx) and not is_nil(line),
       do: {String.slice(line, range), {range, n}}

  defp return_part_number_for(_line, _range, _idx, _n), do: nil

  defp get_sum([], sum), do: sum

  defp get_sum([n | rest], sum) do
    {number, ""} = Integer.parse(n)
    get_sum(rest, sum + number)
  end
end
