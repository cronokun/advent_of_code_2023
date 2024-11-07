defmodule AdventOfCode.TrebuchetTest do
  @moduledoc false

  use ExUnit.Case, async: true

  import AdventOfCode.Trebuchet

  test ".answer/1 returns correct answer" do
    input = ~S"""
    1abc2
    pqr3stu8vwx
    a1b2c3d4e5f
    treb7uchet
    foobar
    """

    assert answer(input) == 142
  end

  test ".final_answer/1 returns correct answer" do
    input = ~S"""
    two1nine
    eightwothree
    abcone2threexyz
    xtwone3four
    4nineeightseven2
    zoneight234
    7pqrstsixteen
    """

    assert final_answer(input) == 281
  end

  test ".final_answer/1 handles special cases" do
    assert final_answer("eighthree") == 83
    assert final_answer("eightwo") == 82
    assert final_answer("fiveight") == 58
    assert final_answer("nineight") == 98
    assert final_answer("oneight") == 18
    assert final_answer("sevenine") == 79
    assert final_answer("threeight") == 38
    assert final_answer("twone") == 21
    assert final_answer("65oneightpln") == 68
  end

  @test_input File.read!("priv/01_trebuchet_calibration")

  test "Day 1, part 1" do
    assert answer(@test_input) == 54_877
  end

  test "Day 1, part 2" do
    assert final_answer(@test_input) == 54_100
  end
end
