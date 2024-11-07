defmodule AdventOfCode.InfiniteStepCounterTest do
  use ExUnit.Case, async: true

  import AdventOfCode.InfiniteStepCounter

  test ".answer/1 returns number of plots one could reach in N steps on infinite map" do
    assert answer(
             """
             ...........
             .....###.#.
             .###.##..#.
             ..#.#...#..
             ....#.#....
             .##..S####.
             .##..#...#.
             .......##..
             .##.#.####.
             .##..##.##.
             ...........
             """,
             6
           ) == 16

    assert answer(
             """
             ...........
             .....###.#.
             .###.##..#.
             ..#.#...#..
             ....#.#....
             .##..S####.
             .##..#...#.
             .......##..
             .##.#.####.
             .##..##.##.
             ...........
             """,
             10
           ) == 50

    assert answer(
             """
             ...........
             .....###.#.
             .###.##..#.
             ..#.#...#..
             ....#.#....
             .##..S####.
             .##..#...#.
             .......##..
             .##.#.####.
             .##..##.##.
             ...........
             """,
             50
           ) == 1594

    assert answer(
             """
             ...........
             .....###.#.
             .###.##..#.
             ..#.#...#..
             ....#.#....
             .##..S####.
             .##..#...#.
             .......##..
             .##.#.####.
             .##..##.##.
             ...........
             """,
             131
           ) == 11_338

    assert answer(
             """
             ..#.#..
             .#...#.
             #.....#
             ...S...
             #.....#
             .#...#.
             ..#.#..
             """,
             20
           ) == 225

    assert answer(
             """
             ###.#..
             #....#.
             ##....#
             ...S...
             #.....#
             .#....#
             ..#.##.
             """,
             20
           ) == 234
  end

  test ".math_answer/1 calculates answer with math" do
    map = File.read!("priv/21_garden_map")

    assert math_answer(map, 2 * 131 + 65) == 91_379
    assert math_answer(map, 4 * 131 + 65) == 295_727
    assert math_answer(map, 6 * 131 + 65) == 616_747
  end

  @test_input File.read!("priv/21_garden_map")

  test "Day 21, part 2" do
    assert math_answer(@test_input) == 596_857_397_104_703
  end
end
