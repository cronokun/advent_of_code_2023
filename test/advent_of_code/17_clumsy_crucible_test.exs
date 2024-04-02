defmodule AdventOfCode.ClumsyCrucibleTest do
  use ExUnit.Case

  import AdventOfCode.ClumsyCrucible

  test ".answer/1 returns the least heat loss" do
    assert 11 ==
             answer(~S"""
             241
             321
             325
             """)

    assert 21 ==
             answer(~S"""
             2413
             3215
             3255
             3446
             """)

    assert 28 ==
             answer(~S"""
             24134
             32154
             32552
             34465
             45466
             """)

    assert 22 ==
             answer(~S"""
             919999999
             919999999
             919999999
             119999999
             199999999
             111999999
             991991111
             991991991
             991111991
             """)

    # Yep, here is a loop!
    assert 16 ==
             answer(~S"""
             111111
             991991
             911991
             911991
             """)

    assert 102 ==
             answer(~S"""
             2413432311323
             3215453535623
             3255245654254
             3446585845452
             4546657867536
             1438598798454
             4457876987766
             3637877979653
             4654967986887
             4564679986453
             1224686865563
             2546548887735
             4322674655533
             """)
  end
end
