defmodule AdventOfCode4NeverTellOddsTest do
  use ExUnit.Case, async: true

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

  test ".final_answer/1 returns sum of coordinates of initial stone position" do
    assert final_answer(~S"""
           19, 13, 30 @ -2,  1, -2
           18, 19, 22 @ -1, -1, -2
           20, 25, 34 @ -2, -2, -4
           12, 31, 28 @ -1, -2, -1
           20, 19, 15 @  1, -5, -3
           """) == 47
  end

  @input_data File.read!("priv/24_hailstone_notes")

  test "Day 24, part 1" do
    assert answer(
             @input_data,
             200_000_000_000_000,
             400_000_000_000_000
           ) == 11_995
  end

  test "Day 24, part 2" do
    assert final_answer(@input_data) == 983_620_716_335_751
  end
end
