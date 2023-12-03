defmodule AdventOfCode.Trebuchet do
  @moduledoc ~S"""
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
  """

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

  defp value(<<_leter::utf8, rest::binary>>, a, b), do: value(rest, a, b)
end
