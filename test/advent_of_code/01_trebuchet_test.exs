defmodule AdventOfCode.TrebuchetTest do
  @moduledoc false

  use ExUnit.Case

  import AdventOfCode.Trebuchet

  test "returns correct answer" do
    input = ~S"""
    1abc2
    pqr3stu8vwx
    a1b2c3d4e5f
    treb7uchet
    foobar
    """

    assert answer(input) == 142
  end
end
