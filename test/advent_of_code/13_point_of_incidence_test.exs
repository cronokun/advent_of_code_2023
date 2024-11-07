defmodule AdventOfCode.PointOfIncidenceTest do
  use ExUnit.Case, async: true

  import AdventOfCode.PointOfIncidence

  test ".answer/1 returns sum of rows and columns left/above the detected mirror" do
    input = ~S"""
    #.##..##.
    ..#.##.#.
    ##......#
    ##......#
    ..#.##.#.
    ..##..##.
    #.#.##.#.

    #...##..#
    #....#..#
    ..##..###
    #####.##.
    #####.##.
    ..##..###
    #....#..#
    """

    assert answer(input) == 405
  end

  test ".final_answer/1 fixes smudge and then finds mirror" do
    input = ~S"""
    #.##..##.
    ..#.##.#.
    ##......#
    ##......#
    ..#.##.#.
    ..##..##.
    #.#.##.#.

    #...##..#
    #....#..#
    ..##..###
    #####.##.
    #####.##.
    ..##..###
    #....#..#
    """

    assert final_answer(input) == 400
  end

  @test_input File.read!("priv/13_patterns")

  test "Day 13, part 1: Point of incidence" do
    assert answer(@test_input) == 35_521
  end

  test "Day 13, part 2: Point of incidence with fixed smudge" do
    assert final_answer(@test_input) == 34_795
  end
end
