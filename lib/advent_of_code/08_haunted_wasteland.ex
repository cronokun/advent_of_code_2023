defmodule AdventOfCode.HauntedWasteland do
  @moduledoc ~S"""
  # Day 8: Haunted Wasteland

  ## Part 1

  You're still riding a camel across Desert Island when you spot a sandstorm quickly
  approaching. When you turn to warn the Elf, she disappears before your eyes! To be fair,
  she had just finished warning you about ghosts a few minutes ago.

  One of the camel's pouches is labeled "maps" - sure enough, it's full of documents
  (your puzzle input) about how to navigate the desert. At least, you're pretty sure
  that's what they are; one of the documents contains a list of left/right instructions,
  and the rest of the documents seem to describe some kind of network of labeled nodes.

  It seems like you're meant to use the left/right instructions to navigate the network.
  Perhaps if you have the camel follow the same instructions, you can escape the haunted wasteland!

  After examining the maps for a bit, two nodes stick out: AAA and ZZZ. You feel
  like AAA is where you are now, and you have to follow the left/right instructions
  until you reach ZZZ.

  This format defines each node of the network individually. For example:

      RL

      AAA = (BBB, CCC)
      BBB = (DDD, EEE)
      CCC = (ZZZ, GGG)
      DDD = (DDD, DDD)
      EEE = (EEE, EEE)
      GGG = (GGG, GGG)
      ZZZ = (ZZZ, ZZZ)

  Starting with AAA, you need to look up the next element based on the next left/right
  instruction in your input. In this example, start with AAA and go right (R) by
  choosing the right element of AAA, CCC. Then, L means to choose the left element
  of CCC, ZZZ. By following the left/right instructions, you reach ZZZ in 2 steps.

  Of course, you might not find ZZZ right away. If you run out of left/right instructions,
  repeat the whole sequence of instructions as necessary: RL really means RLRLRLRLRLRLRLRL...
  and so on. For example, here is a situation that takes 6 steps to reach ZZZ:

      LLR

      AAA = (BBB, BBB)
      BBB = (AAA, ZZZ)
      ZZZ = (ZZZ, ZZZ)

  Starting at AAA, follow the left/right instructions. **How many steps are required to reach ZZZ?**

  ## Part 2

  --- Part Two ---

  The sandstorm is upon you and you aren't any closer to escaping the wasteland.
  You had the camel follow the instructions, but you've barely left your starting position.
  It's going to take significantly more steps to escape!

  What if the map isn't for people - what if the map is for ghosts? Are ghosts even
  bound by the laws of spacetime? Only one way to find out.

  After examining the maps a bit longer, your attention is drawn to a curious fact:
  the number of nodes with names ending in A is equal to the number ending in Z!
  If you were a ghost, you'd probably just start at every node that ends with A
  and follow all of the paths at the same time until they all simultaneously end up
  at nodes that end with Z.

  For example:

      LR

      11A = (11B, XXX)
      11B = (XXX, 11Z)
      11Z = (11B, XXX)
      22A = (22B, XXX)
      22B = (22C, 22C)
      22C = (22Z, 22Z)
      22Z = (22B, 22B)
      XXX = (XXX, XXX)

  Here, there are two starting nodes, 11A and 22A (because they both end with A).
  As you follow each left/right instruction, use that instruction to simultaneously
  navigate away from both nodes you're currently on. Repeat this process until all
  of the nodes you're currently on end with Z. (If only some of the nodes you're
  on end with Z, they act like any other node and you continue as normal.)
  In this example, you would proceed as follows:

  - Step 0: You are at 11A and 22A.
  - Step 1: You choose all of the left paths, leading you to 11B and 22B.
  - Step 2: You choose all of the right paths, leading you to 11Z and 22C.
  - Step 3: You choose all of the left paths, leading you to 11B and 22Z.
  - Step 4: You choose all of the right paths, leading you to 11Z and 22B.
  - Step 5: You choose all of the left paths, leading you to 11B and 22C.
  - Step 6: You choose all of the right paths, leading you to 11Z and 22Z.

  So, in this example, you end up entirely on nodes that end in Z after 6 steps.

  Simultaneously start on every node that ends with A. **How many steps does it take
  before you're only on nodes that end with Z?**
  """

  @doc "How many steps are requred to reach end"
  def answer(input) do
    {instructions, map} = parse_input(input)
    reduce_a_map(map, instructions, "AAA", 0)
  end

  defp reduce_a_map(_map, _instructions, "ZZZ", acc), do: acc

  defp reduce_a_map(map, [i | is], cur, acc) do
    next = get_next_direction(cur, i, map)
    reduce_a_map(map, is ++ [i], next, acc + 1)
  end

  def final_answer(input) do
    {instructions, map} = parse_input(input)

    map
    |> get_start_directions()
    |> Enum.map(fn s -> get_loop_count(map, instructions, s, 0) end)
    |> calculate_steps_number()
  end

  defp calculate_steps_number(ns) do
    ms = (for i <- ns, j <- ns, i != j, do: Integer.gcd(i, j))
    [m] = Enum.uniq(ms)

    x = ns
    |> Enum.map(& div(&1, m))
    |> Enum.product()

    x * m
  end

  defp get_start_directions(map),
    do: map |> Map.keys() |> Enum.filter(&String.ends_with?(&1, "A"))

  defp get_next_direction(cur, "L", map), do: map |> Map.get(cur) |> elem(0)
  defp get_next_direction(cur, "R", map), do: map |> Map.get(cur) |> elem(1)

  defp get_loop_count(map, [i | is], cur, acc) do
    if String.ends_with?(cur, "Z") do
      acc
    else
      next = get_next_direction(cur, i, map)
      get_loop_count(map, is ++ [i], next, acc + 1)
    end
  end

  # ---- Parser ----

  def parse_input(input) do
    [instructions, data] = String.split(input, "\n\n", trim: true)
    instructions = String.split(instructions, "", trim: true)

    map =
      data
      |> String.split("\n", trim: true)
      |> Enum.map(&parse_map_line/1)
      |> Map.new()

    {instructions, map}
  end

  defp parse_map_line(line) do
    [c, l, r] =
      Regex.run(~r/([1-9,A-Z]{3}) = \(([1-9,A-Z]{3}), ([1-9,A-Z]{3})\)/, line,
        capture: :all_but_first
      )

    {c, {l, r}}
  end
end
