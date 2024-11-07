defmodule AdventOfCode.HotSpringsTest do
  use ExUnit.Case, async: true

  import AdventOfCode.HotSprings

  test ".answer/1 returns sum of all possible arrangements" do
    input = ~S"""
    ???.### 1,1,3
    .??..??...?##. 1,1,3
    ?#?#?#?#?#?#?#? 1,3,1,6
    ????.#...#... 4,1,1
    ????.######..#####. 1,6,5
    ?###???????? 3,2,1
    """

    assert answer(input, 1) == 21
  end

  test ".final_answer/1 returns new sum of all possible arrangements" do
    input = ~S"""
    ???.### 1,1,3
    .??..??...?##. 1,1,3
    ?#?#?#?#?#?#?#? 1,3,1,6
    ????.#...#... 4,1,1
    ????.######..#####. 1,6,5
    ?###???????? 3,2,1
    """

    assert answer(input, 5) == 525_152
  end

  @test_input File.read!("priv/12_condition_records")

  test "Day 12, part 1: Hot springs" do
    assert answer(@test_input, 1) == 7_007
  end

  test "Day 12, part 2: Unfolded hot springs" do
    assert answer(@test_input, 5) == 3_476_169_006_222
  end
end
