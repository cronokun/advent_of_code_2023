defmodule AdventOfCode.CamelCardsTest do
  use ExUnit.Case

  import AdventOfCode.CamelCards

  test ".answer/1 returns total winnings" do
    input = ~S"""
    32T3K 765
    T55J5 684
    KK677 28
    KTJJT 220
    QQQJA 483
    """

    assert answer(input) == 6440
  end
end
