defmodule AdventOfCode.FloorWillBeLavaTest do
  use ExUnit.Case

  import AdventOfCode.FloorWillBeLava

  test ".answer/1 returns number of energized tiles" do
    input = ~S"""
    .|...\....
    |.-.\.....
    .....|-...
    ........|.
    ..........
    .........\
    ..../.\\..
    .-.-/..|..
    .|....-|.\
    ..//.|....
    """

    assert answer(input) == 46
  end

  test ".final_answer/1 returns maximum number of energized tiles" do
    input = ~S"""
    .|...\....
    |.-.\.....
    .....|-...
    ........|.
    ..........
    .........\
    ..../.\\..
    .-.-/..|..
    .|....-|.\
    ..//.|....
    """

    assert final_answer(input) == 51
  end
end
