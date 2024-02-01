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

  test ".final_answer/1 returns number of ways to win the race" do
    input = ~S"""
    Time:      7  15   30
    Distance:  9  40  200
    """

    assert final_answer(input) == 71_503

    input = ~S"""
    Time: 82
    Distance: 1011
    """

    assert final_answer(input) == 51

    input = ~S"""
    Time: 92
    Distance: 1487
    """

    assert final_answer(input) == 51

    input = ~S"""
    Time: 84
    Distance: 1110
    """

    assert final_answer(input) == 51
  end
end
