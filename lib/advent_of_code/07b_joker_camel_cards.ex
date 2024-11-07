defmodule AdventOfCode.JokerCamelCards do
  @moduledoc """
  # Day 7: Camel Cards

  ## Part 2

  To make things a little more interesting, the Elf introduces one additional rule.
  Now, J cards are jokers - wildcards that can act like whatever card would make
  the hand the strongest type possible.

  To balance this, J cards are now the weakest individual cards, weaker even than 2.
  The other cards stay in the same order: A, K, Q, T, 9, 8, 7, 6, 5, 4, 3, 2, J.

  J cards can pretend to be whatever card is best for the purpose of determining hand
  type; for example, QJJQ2 is now considered four of a kind. However, for the purpose
  of breaking ties between two hands of the same type, J is always treated as J, not
  the card it's pretending to be: JKKK2 is weaker than QQQQ2 because J is weaker than Q.

  Now, the above example goes very differently:

      32T3K 765
      T55J5 684
      KK677 28
      KTJJT 220
      QQQJA 483

  - 32T3K is still the only one pair; it doesn't contain any jokers, so its strength
    doesn't increase.
  - KK677 is now the only two pair, making it the second-weakest hand.
  - T55J5, KTJJT, and QQQJA are now all four of a kind! T55J5 gets rank 3, QQQJA gets
    rank 4, and KTJJT gets rank 5.

  With the new joker rule, the total winnings in this example are 5905.

  Using the new joker rule, find the rank of every hand in your set. **What are the
  new total winnings?**
  """

  @doc "Total winnings with joker"
  def answer(input) do
    input
    |> parse_input()
    |> Enum.sort(&hand_sorter/2)
    |> calc_wins()
  end

  defp parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      [hand, bid] = String.split(line, " ")

      {
        String.split(hand, "", trim: true),
        String.to_integer(bid)
      }
    end)
  end

  defp hand_sorter({a, _}, {b, _}),
    do: compare_hands({a, hand_strength(a)}, {b, hand_strength(b)})

  defp compare_hands({a, a_str}, {b, b_str}) when a_str == b_str,
    do: cards_stength(a) < cards_stength(b)

  defp compare_hands({_a, a_str}, {_b, b_str}), do: a_str < b_str

  defp calc_wins(hands) do
    hands
    |> Enum.reduce({1, 0}, fn {_, bid}, {rank, total} -> {rank + 1, total + rank * bid} end)
    |> elem(1)
  end

  defp hand_strength(hand) do
    {jokers, rest} = Enum.split_with(hand, &(&1 == "J"))

    freq =
      rest
      |> Enum.frequencies()
      |> Map.values()
      |> Enum.sort(:desc)

    hand_strength_with_jokers(length(jokers), freq)
  end

  # credo:disable-for-lines:30
  defp hand_strength_with_jokers(jokers, others) do
    case {jokers, others} do
      # Five of a kind
      {5, []} -> 7
      {4, [1]} -> 7
      {3, [2]} -> 7
      {2, [3]} -> 7
      {1, [4]} -> 7
      {0, [5]} -> 7
      # Four of a kind
      {3, [1, 1]} -> 6
      {2, [2, 1]} -> 6
      {1, [3, 1]} -> 6
      {0, [4, 1]} -> 6
      # Full house
      {1, [2, 2]} -> 5
      {0, [3, 2]} -> 5
      # Three of a kind
      {2, [1, 1, 1]} -> 4
      {1, [2, 1, 1]} -> 4
      {0, [3, 1, 1]} -> 4
      # Two pairs
      {0, [2, 2, 1]} -> 3
      # Pair
      {1, [1, 1, 1, 1]} -> 2
      {0, [2, 1, 1, 1]} -> 2
      # High card
      {0, [1, 1, 1, 1, 1]} -> 1
    end
  end

  @cards_with_joker %{
    "J" => 1,
    "2" => 2,
    "3" => 3,
    "4" => 4,
    "5" => 5,
    "6" => 6,
    "7" => 7,
    "8" => 8,
    "9" => 9,
    "T" => 10,
    "Q" => 11,
    "K" => 12,
    "A" => 13
  }

  defp cards_stength(hand) do
    Enum.map(hand, fn card -> Map.get(@cards_with_joker, card) end)
  end
end
