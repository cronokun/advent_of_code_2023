defmodule AdventOfCode.CosmicExpansionTest do
  use ExUnit.Case

  import AdventOfCode.CosmicExpansion, only: [answer: 2]

  @tag :focus
  test ".answer/1 returns sum of shortest path lengths for all galaxy pairs" do
    input = ~S"""
    ...#......
    .......#..
    #.........
    ..........
    ......#...
    .#........
    .........#
    ..........
    .......#..
    #...#.....
    """

    assert answer(input, 2) == 374
    assert answer(input, 10) == 1030
    assert answer(input, 100) == 8410
  end
end
