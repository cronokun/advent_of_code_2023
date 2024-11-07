defmodule AdventOfCode.ReallyLongWalkTest do
  use ExUnit.Case, async: true

  import AdventOfCode.ReallyLongWalk

  test ".answer/1 returns the number of steps of the really longest hike" do
    input = ~S"""
    #.#####################
    #.......#########...###
    #######.#########.#.###
    ###.....#.>.>.###.#.###
    ###v#####.#v#.###.#.###
    ###.>...#.#.#.....#...#
    ###v###.#.#.#########.#
    ###...#.#.#.......#...#
    #####.#.#.#######.#.###
    #.....#.#.#.......#...#
    #.#####.#.#.#########v#
    #.#...#...#...###...>.#
    #.#.#v#######v###.###v#
    #...#.>.#...>.>.#.###.#
    #####v#.#.###v#.#.###.#
    #.....#...#...#.#.#...#
    #.#########.###.#.#.###
    #...###...#...#...#.###
    ###.###.#.###v#####v###
    #...#...#.#.>.>.#.>.###
    #.###.###.#.###.#.#v###
    #.....###...###...#...#
    #####################.#
    """

    assert answer(input) == 154
  end

  @test_input File.read!("priv/23_hiking_trails_map")

  test "Day 23, part 2" do
    assert answer(@test_input) == 6_350
  end
end
