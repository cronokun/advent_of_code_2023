defmodule AdventOfCode.AdvancedTrebuchetTest do
  @moduledoc false

  use ExUnit.Case

  import AdventOfCode.AdvancedTrebuchet

  test "returns correct answer" do
    input = ~S"""
    two1nine
    eightwothree
    abcone2threexyz
    xtwone3four
    4nineeightseven2
    zoneight234
    7pqrstsixteen
    """

    assert answer(input) == 281
  end

  test "special cases" do
    assert answer("eighthree") == 83
    assert answer("eightwo") == 82
    assert answer("fiveight") == 58
    assert answer("nineight") == 98
    assert answer("oneight") == 18
    assert answer("sevenine") == 79
    assert answer("threeight") == 38
    assert answer("twone") == 21
    assert answer("65oneightpln") == 68
  end
end
