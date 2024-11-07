defmodule AdventOfCode.JokerCamelCardsTest do
  use ExUnit.Case, async: true

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

  @test_input File.read!("priv/07_hands_and_bids")

  test "Day 7, part 2" do
    assert answer(@test_input) == 252_113_488
  end
end
