defmodule AdventOfCode.StepCounterTest do
  use ExUnit.Case

  import AdventOfCode.StepCounter

  test ".answer/1 returns number of garden plots one could reach in exactly N steps" do
    assert answer("""
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
      """, 6) == 16
  end
end
