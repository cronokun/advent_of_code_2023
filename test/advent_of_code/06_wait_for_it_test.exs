defmodule AdventOfCode.WaitForItTest do
  use ExUnit.Case, async: true

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

  @test_input File.read!("priv/06_race_records")

  test "Day 6, part 1" do
    assert answer(@test_input) == 3_316_275
  end

  test "Day 6, part 2" do
    assert final_answer(@test_input) == 27_102_791
  end
end
