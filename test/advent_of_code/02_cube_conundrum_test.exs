defmodule AdventOfCode.CubeConundrumTest do
  use ExUnit.Case, async: true

  import AdventOfCode.CubeConundrum

  test ".answer/1 returns sum of the possible game IDs" do
    input = ~S"""
    Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
    Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
    Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
    Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
    Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
    """

    assert answer(input) == 8
  end

  test ".final_answer/1 retunrns sum of the powers of all sets" do
    input = ~S"""
    Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
    Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
    Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
    Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
    Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
    """

    assert final_answer(input) == 2286
  end

  @test_input File.read!("priv/02_cube_game_records")

  test "Day 2, part 1" do
    assert answer(@test_input) == 2_061
  end

  test "Day 2, part 2" do
    assert final_answer(@test_input) == 72_596
  end
end
