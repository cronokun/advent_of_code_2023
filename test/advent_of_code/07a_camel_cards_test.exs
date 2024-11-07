defmodule AdventOfCode.CamelCardsTest do
  use ExUnit.Case, async: true

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

  @test_input File.read!("priv/07_hands_and_bids")

  test "Day 7, part 1" do
    assert answer(@test_input) == 251_806_792
  end
end
