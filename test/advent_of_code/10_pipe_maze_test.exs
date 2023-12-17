defmodule AdventOfCode.PipeMazeTest do
  use ExUnit.Case

  import AdventOfCode.PipeMaze

  test ".answer/1 returns steps to the farthest point from the start" do
    input1 = ~S"""
    .....
    .S-7.
    .|.|.
    .L-J.
    .....
    """

    input2 = ~S"""
    ..F7.
    .FJ|.
    SJ.L7
    |F--J
    LJ...
    """

    assert answer(input1) == 4
    assert answer(input2) == 8
  end

  test ".answer/1 ignores unconnected pipes" do
    input1 = ~S"""
    -L|F7
    7S-7|
    L|7||
    -L-J|
    L|-JF
    """

    input2 = ~S"""
    7-F7-
    .FJ|7
    SJLL7
    |F--J
    LJ.LJ
    """

    assert answer(input1) == 4
    assert answer(input2) == 8
  end
end
