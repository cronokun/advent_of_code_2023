defmodule AdventOfCode.JokerCamelCardsTest do
  use ExUnit.Case

  import AdventOfCode.JokerCamelCards

  test ".answer/1 return total winnings counting jokers" do
    input = ~S"""
    32T3K 765
    T55J5 684
    KK677 28
    KTJJT 220
    QQQJA 483
    """

    assert answer(input) == 5905
  end
end
