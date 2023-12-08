defmodule AdventOfCode.WaitForItTest do
  use ExUnit.Case

  import AdventOfCode.WaitForIt

  test ".answer/1 returns number of ways to win all races" do
    input = ~S"""
    Time:      7  15   30
    Distance:  9  40  200
    """

    assert answer(input) == 288
  end
end
