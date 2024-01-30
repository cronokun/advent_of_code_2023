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
end
