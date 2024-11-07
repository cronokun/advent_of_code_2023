defmodule AdventOfCode.CosmicExpansionTest do
  use ExUnit.Case, async: true

  import AdventOfCode.CosmicExpansion, only: [answer: 2]

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

  @test_input File.read!("priv/11_galaxy_image")

  test "Day 11, part 1" do
    assert answer(@test_input, 2) == 9_918_828
  end

  test "Day 11, part 2" do
    assert answer(@test_input, 1_000_000) == 692_506_533_832
  end
end
