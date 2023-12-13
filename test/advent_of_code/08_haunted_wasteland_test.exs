defmodule AdventOfCode.HauntedWastelandTest do
  use ExUnit.Case

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
end
