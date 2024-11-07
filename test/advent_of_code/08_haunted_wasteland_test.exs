defmodule AdventOfCode.HauntedWastelandTest do
  use ExUnit.Case, async: true

  import AdventOfCode.HauntedWasteland

  test ".answer/1 return number of steps required to reach the end" do
    input = ~S"""
    RL

    AAA = (BBB, CCC)
    BBB = (DDD, EEE)
    CCC = (ZZZ, GGG)
    DDD = (DDD, DDD)
    EEE = (EEE, EEE)
    GGG = (GGG, GGG)
    ZZZ = (ZZZ, ZZZ)
    """

    assert answer(input) == 2

    input = ~S"""
    LLR

    AAA = (BBB, BBB)
    BBB = (AAA, ZZZ)
    ZZZ = (ZZZ, ZZZ)
    """

    assert answer(input) == 6
  end

  test ".final_answer/1" do
    input = ~S"""
    LR

    11A = (11B, XXX)
    11B = (XXX, 11Z)
    11Z = (11B, XXX)
    22A = (22B, XXX)
    22B = (22C, 22C)
    22C = (22Z, 22Z)
    22Z = (22B, 22B)
    XXX = (XXX, XXX)
    """

    assert final_answer(input) == 6
  end

  @test_input File.read!("priv/08_desert_map")

  test "Day 8, part 1" do
    assert answer(@test_input) == 21_883
  end

  test "Day 8, part 2" do
    assert final_answer(@test_input) == 12_833_235_391_111
  end
end
