defmodule AdventOfCode.PointOfIncidenceTest do
  use ExUnit.Case

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
end
