defmodule AdventOfCode.FloorWillBeLavaTest do
  use ExUnit.Case, async: true

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

  @test_input File.read!("priv/16_contraption_layout")

  test "Day 16, part 1" do
    assert answer(@test_input) == 6_622
  end

  test "Day 16, part 2" do
    assert final_answer(@test_input) == 7_130
  end
end
