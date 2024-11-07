defmodule AdventOfCode.SandSlabsTest do
  @moduledoc """
  # Test Inputs (mostly for part 2)

  * Main test input

    | # |  | # |
    | # |  | # |
    |###|  | # |
    |# #|  |###|
    |###|  |# #|
    | # |  |###|
    +---+  +---+
      x      y

  * Interlocked

    Block A is uniq prop for C, but not for D (D is proped by B).

    |  ##  |  |#|  I
    | #### |  |#|  H
    |##  # |  |#|  E, F, G
    |## ###|  |#|  C, D
    |#### #|  |#|  A, B
    +------+  +-+
        x      y

  * Diamond

    |  #  |
    | ### |
    |## ##|
    | ### |
    |  #  |
    +-----+
       x

  * Reverse tree

    |# # # #| |#|
    |### ###| |#|
    | ##### | |#|
    |  ###  | |#|
    +-------+ +-+
        x      y

  * Simple tower

    | # |
    | ##|
    |  #|
    | ##|
    |## |
    | ##|
    |## |
    +---+
      x
      
  * Symetric layers

    | ##### |
    |### ###|
    |# ### #|
    |### ###|
    |# # # #|
    |#######|
    +-------+
        x
  """

  use ExUnit.Case, async: true

  import AdventOfCode.SandSlabs

  @main_test ~S"""
  1,0,1~1,2,1
  0,0,2~2,0,2
  0,2,3~2,2,3
  0,0,4~0,2,4
  2,0,5~2,2,5
  0,1,6~2,1,6
  1,1,8~1,1,9
  """

  @interlocked ~S"""
  0,0,0~3,0,0
  5,0,0~5,0,0
  0,0,1~1,0,1
  3,0,1~5,0,1
  0,0,2~0,0,2
  1,0,2~1,0,2
  4,0,2~4,0,2
  1,0,3~4,0,3
  2,0,4~3,0,4
  """

  @reverse_tree ~S"""
  2,0,0~4,0,0
  1,0,1~5,0,1
  0,0,2~2,0,2
  4,0,2~6,0,2
  0,0,3~0,0,3
  2,0,3~2,0,3
  4,0,3~4,0,3
  6,0,3~6,0,3
  """

  @diamond ~S"""
  2,0,0~2,0,0
  1,0,1~3,0,1
  0,0,2~1,0,2
  3,0,2~4,0,2
  1,0,3~3,0,3
  2,0,4~2,0,4
  """

  @simple_tower ~S"""
  0,0,0~1,0,0
  1,0,1~2,0,1
  0,0,2~1,0,2
  1,0,3~2,0,3
  2,0,4~2,0,4
  1,0,5~2,0,5
  1,0,6~1,0,6
  """

  @symetric_layers ~S"""
  0,0,0~6,0,0
  0,0,1~0,0,1
  2,0,1~2,0,1
  4,0,1~4,0,1
  6,0,1~6,0,1
  0,0,2~2,0,2
  3,0,2~6,0,2
  0,0,3~0,0,3
  2,0,3~4,0,3
  6,0,3~6,0,3
  0,0,4~2,0,4
  3,0,4~6,0,4
  1,0,5~5,0,5
  """

  test ".answer/1 return how many bricks could be safely chosen as the one to get disintegrated" do
    assert answer(@main_test) == 5
    assert answer(@interlocked) == 5
  end

  test ".answer/1 sorts input by Z first" do
    assert answer(~S"""
           4,2,67~4,5,67
           7,2,224~7,2,226
           8,3,40~9,3,40
           0,4,177~0,7,177
           5,6,192~5,8,192
           2,0,50~5,0,50
           4,1,190~6,1,190
           4,0,193~4,1,193
           6,5,51~6,5,53
           0,4,186~0,8,186
           4,5,28~6,5,28
           7,3,13~9,3,13
           5,0,300~5,3,300
           6,0,99~6,2,99
           7,2,55~7,5,55
           4,1,179~4,2,179
           3,2,94~5,2,94
           8,7,192~8,7,194
           4,5,257~6,5,257
           8,4,295~8,6,295
           6,6,178~8,6,178
           6,8,253~9,8,253
           7,6,232~7,9,232
           3,3,146~3,4,146
           5,1,55~6,1,55
           """) == 13
  end

  test ".final_answer/1 return the sum of the number of other bricks that would fall" do
    assert final_answer(@simple_tower) == 21
    assert final_answer(@main_test) == 7
    assert final_answer(@reverse_tree) == 17
    assert final_answer(@diamond) == 10
    assert final_answer(@interlocked) == 7
    assert final_answer(@symetric_layers) == 14
  end

  @test_input File.read!("priv/22_bricks_snapshot")

  test "Day 22, part 1" do
    assert answer(@test_input) == 426
  end

  test "Day 22, part 2" do
    assert final_answer(@test_input) == 61_920
  end
end
