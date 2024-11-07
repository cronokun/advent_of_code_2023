defmodule AdventOfCode.StepCounterTest do
  use ExUnit.Case, async: true

  import AdventOfCode.StepCounter

  test ".answer/1 returns number of garden plots one could reach in exactly N steps" do
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
  end

  @test_input File.read!("priv/21_garden_map")

  test "Day 21, part 1" do
    assert answer(@test_input) == 3_617
  end
end
