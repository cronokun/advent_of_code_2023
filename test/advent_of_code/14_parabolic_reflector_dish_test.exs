defmodule AdventOfCode.ParabolicReflectorDishTest do
  use ExUnit.Case, async: true

  import AdventOfCode.ParabolicReflectorDish

  test ".answer/1 returns total load on the north support beams" do
    input = ~S"""
    O....#....
    O.OO#....#
    .....##...
    OO.#O....O
    .O.....O#.
    O.#..O.#.#
    ..O..#O..O
    .......O..
    #....###..
    #OO..#....
    """

    assert answer(input) == 136
  end

  test ".final_answer/1 returns total load on the north support beams after 1B spin cycles" do
    input = ~S"""
    O....#....
    O.OO#....#
    .....##...
    OO.#O....O
    .O.....O#.
    O.#..O.#.#
    ..O..#O..O
    .......O..
    #....###..
    #OO..#....
    """

    assert final_answer(input, 1_000_000_000) == 64
  end

  @test_input File.read!("priv/14_platform_map")

  test "Day 14, part 1" do
    assert answer(@test_input) == 107_430
  end

  test "Day 14, part 2" do
    assert final_answer(@test_input, 1_000_000_000) == 96_317
  end
end
