defmodule AdventOfCode.Trebuchet do
  @moduledoc """
  # Day 1

  ## Part One

  As they're making the final adjustments, they discover that their calibration document
  (your puzzle input) has been amended by a very young Elf who was apparently just
  excited to show off her art skills. Consequently, the Elves are having trouble reading
  the values on the document.

  The newly-improved calibration document consists of lines of text; each line originally
  contained a specific calibration value that the Elves now need to recover. On each line,
  the calibration value can be found by combining the first digit and the last digit
  (in that order) to form a single two-digit number.

  For example:

    1abc2
    pqr3stu8vwx
    a1b2c3d4e5f
    treb7uchet

  In this example, the calibration values of these four lines are 12, 38, 15, and 77.
  Adding these together produces 142.

  Consider your entire calibration document. What is the sum of all of the calibration values?

  ## Part Two

  Your calculation isn't quite right. It looks like some of the digits are actually
  spelled out with letters: `one`, `two`, `three`, `four`, `five`, `six`, `seven`,
  `eight`, and `nine` also count as valid "digits".

  Equipped with this new information, you now need to find the real first and last digit
  on each line. For example:

    two1nine
    eightwothree
    abcone2threexyz
    xtwone3four
    4nineeightseven2
    zoneight234
    7pqrstsixteen

  In this example, the calibration values are 29, 83, 13, 24, 42, 14, and 76.
  Adding these together produces 281.

  What is the sum of all of the calibration values?
  """

  def answer(input) do
    input
    |> String.split("\n")
    |> Enum.reduce(0, fn line, total -> total + num_value(line, nil, nil) end)
  end

  defp num_value("", a, b), do: (a || 0) * 10 + (b || 0)

  for n <- 1..9 do
    defp num_value(<<unquote(to_string(n)), rest::binary>>, a, _b),
      do: num_value(rest, a || unquote(n), unquote(n))
  end

  defp num_value(<<_leter::utf8, rest::binary>>, a, b), do: num_value(rest, a, b)

  # ---- Part 2 --------

  @digits [
    {"one", 1},
    {"two", 2},
    {"three", 3},
    {"four", 4},
    {"five", 5},
    {"six", 6},
    {"seven", 7},
    {"eight", 8},
    {"nine", 9}
  ]

  def final_answer(input) do
    input
    |> String.split("\n")
    |> Enum.reduce(0, fn line, total -> total + value(line, nil, nil) end)
  end

  defp value("", a, b), do: (a || 0) * 10 + (b || 0)

  for n <- 1..9 do
    defp value(<<unquote(to_string(n)), rest::binary>>, a, _b),
      do: value(rest, a || unquote(n), unquote(n))
  end

  defp value(<<"eighthree", rest::binary>>, a, _b), do: value("three" <> rest, a || 8, 8)
  defp value(<<"eightwo", rest::binary>>, a, _b), do: value("two" <> rest, a || 8, 8)
  defp value(<<"fiveight", rest::binary>>, a, _b), do: value("eight" <> rest, a || 5, 5)
  defp value(<<"nineight", rest::binary>>, a, _b), do: value("eight" <> rest, a || 9, 9)
  defp value(<<"oneight", rest::binary>>, a, _b), do: value("eight" <> rest, a || 1, 1)
  defp value(<<"sevenine", rest::binary>>, a, _b), do: value("nine" <> rest, a || 7, 7)
  defp value(<<"threeight", rest::binary>>, a, _b), do: value("eight" <> rest, a || 3, 3)
  defp value(<<"twone", rest::binary>>, a, _b), do: value("one" <> rest, a || 2, 2)

  for {str, n} <- @digits do
    defp value(<<unquote(str), rest::binary>>, a, _b),
      do: value(rest, a || unquote(n), unquote(n))
  end

  defp value(<<_char::utf8, rest::binary>>, a, b), do: value(rest, a, b)
end
