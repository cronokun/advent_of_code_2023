defmodule AdventOfCode.BiggerFoodProductionProblemTest do
  use ExUnit.Case

  import AdventOfCode.BiggerFoodProductionProblem

  test ".answer/1 returns lower location number" do
    input = ~S"""
    seeds: 79 14 55 13

    seed-to-soil map:
    50 98 2
    52 50 48

    soil-to-fertilizer map:
    0 15 37
    37 52 2
    39 0 15

    fertilizer-to-water map:
    49 53 8
    0 11 42
    42 0 7
    57 7 4

    water-to-light map:
    88 18 7
    18 25 70

    light-to-temperature map:
    45 77 23
    81 45 19
    68 64 13

    temperature-to-humidity map:
    0 69 1
    1 0 69

    humidity-to-location map:
    60 56 37
    56 93 4
    """

    assert answer(input) == 46
  end

  test ".answer/1 correctly processes partial matches" do
    input = ~S"""
    seeds: 100 20

    test:
    1005 105 10

    first map:
    1000 0 100
    1000 900 100
    200 50 100

    second map:
    350 250 10
    1000 0   100
    400 260 5
    """

    assert answer(input) == 265
  end
end
