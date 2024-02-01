defmodule AdventOfCode.ParabolicReflectorDishTest do
  use ExUnit.Case

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
end
