defmodule AdventOfCode.AdvancedTrebuchet do
  @moduledoc ~S"""
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

  def answer(input) do
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
