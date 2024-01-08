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

  test ".final_answer/1 returns number of tiles that are enclosed by the loop" do
    input10 = ~S"""
    ...........
    .S-------7.
    .|F-----7|.
    .||.....||.
    .||.....||.
    .|L-7.F-J|.
    .|..|.|..|.
    .L--J.L--J.
    ...........
    """

    input11 = ~S"""
    ..........
    .S------7.
    .|F----7|.
    .||....||.
    .||....||.
    .|L-7F-J|.
    .|..||..|.
    .L--JL--J.
    ..........
    """

    input20 = ~S"""
    .F----7F7F7F7F-7....
    .|F--7||||||||FJ....
    .||.FJ||||||||L7....
    FJL7L7LJLJ||LJ.L-7..
    L--J.L7...LJS7F-7L7.
    ....F-J..F7FJ|L7L7L7
    ....L7.F7||L7|.L7L7|
    .....|FJLJ|FJ|F7|.LJ
    ....FJL-7.||.||||...
    ....L---J.LJ.LJLJ...
    """

    input30 = ~S"""
    FF7FSF7F7F7F7F7F---7
    L|LJ||||||||||||F--J
    FL-7LJLJ||||||LJL-77
    F--JF--7||LJLJ7F7FJ-
    L---JF-JLJ.||-FJLJJ7
    |F|F-JF---7F7-L7L|7|
    |FFJF7L7F-JF7|JL---7
    7-L-JL7||F7|L7F-7F7|
    L.L7LFJ|||||FJL7||LJ
    L7JLJL-JLJLJL--JLJ.L
    """

    input31 = ~S"""
    FF7FSF7F7F7F7F7F---7
    L|LJ||||||||||||F--J
    FL-7LJLJ||||||LJL-77
    F--JF--7||LJLJIF7FJ-
    L---JF-JLJIIIIFJLJJ7
    |F|F-JF---7IIIL7L|7|
    |FFJF7L7F-JF7IIL---7
    7-L-JL7||F7|L7F-7F7|
    L.L7LFJ|||||FJL7||LJ
    L7JLJL-JLJLJL--JLJ.L
    """

    assert final_answer(input10) == 4
    assert final_answer(input11) == 4
    assert final_answer(input20) == 8
    assert final_answer(input30) == 10
    assert final_answer(input31) == 10
  end
end
