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
end
