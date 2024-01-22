defmodule AdventOfCode.HotSpringsTest do
  use ExUnit.Case

  import AdventOfCode.HotSprings, only: [answer: 1]

  test ".answer/1 returns sum of all possible arrangements" do
    input = ~S"""
    ???.### 1,1,3
    .??..??...?##. 1,1,3
    ?#?#?#?#?#?#?#? 1,3,1,6
    ????.#...#... 4,1,1
    ????.######..#####. 1,6,5
    ?###???????? 3,2,1
    """

    assert answer(input) == 21
  end
end
