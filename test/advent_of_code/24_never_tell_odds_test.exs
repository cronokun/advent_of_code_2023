defmodule AdventOfCode4NeverTellOddsTest do
  use ExUnit.Case

  import AdventOfCode.NeverTellOdds

  test ".answer/1 returns number of intersections that occur withing test area" do
    assert answer(
             ~S"""
             19, 13, 30 @ -2,  1, -2
             18, 19, 22 @ -1, -1, -2
             20, 25, 34 @ -2, -2, -4
             12, 31, 28 @ -1, -2, -1
             20, 19, 15 @  1, -5, -3
             """,
             7,
             27
           ) == 2
  end

  test ".answer/1 with test input" do
    assert answer(
             File.read!("priv/24_hailstone_notes"),
             200_000_000_000_000,
             400_000_000_000_000
           ) == 11_995
  end
end
