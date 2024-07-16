defmodule AdventOfCode.ClumsyCrucible do
  @moduledoc """
  # Day 17: Clumsy Crucible

  ## Part 1

  The lava starts flowing rapidly once the Lava Production Facility is operational. As you leave,
  the reindeer offers you a parachute, allowing you to quickly reach Gear Island.

  As you descend, your bird's-eye view of Gear Island reveals why you had trouble finding anyone
  on your way up: half of Gear Island is empty, but the half below you is a giant factory city!

  You land near the gradually-filling pool of lava at the base of your new lavafall. Lavaducts
  will eventually carry the lava throughout the city, but to make use of it immediately, Elves
  are loading it into large crucibles on wheels.

  The crucibles are top-heavy and pushed by hand. Unfortunately, the crucibles become very
  difficult to steer at high speeds, and so it can be hard to go in a straight line for very long.

  To get Desert Island the machine parts it needs as soon as possible, you'll need to find the
  best way to get the crucible from the lava pool to the machine parts factory. To do this, you
  need to minimize heat loss while choosing a route that doesn't require the crucible to go in
  a straight line for too long.

  Fortunately, the Elves here have a map (your puzzle input) that uses traffic patterns, ambient
  temperature, and hundreds of other parameters to calculate exactly how much heat loss can be
  expected for a crucible entering any particular city block.

  For example:

      2413432311323
      3215453535623
      3255245654254
      3446585845452
      4546657867536
      1438598798454
      4457876987766
      3637877979653
      4654967986887
      4564679986453
      1224686865563
      2546548887735
      4322674655533

  Each city block is marked by a single digit that represents the amount of heat loss if the
  crucible enters that block. The starting point, the lava pool, is the top-left city block;
  the destination, the machine parts factory, is the bottom-right city block. (Because you already
  start in the top-left block, you don't incur that block's heat loss unless you leave that block
  and then return to it.)

  Because it is difficult to keep the top-heavy crucible going in a straight line for very long,
  it can move at most three blocks in a single direction before it must turn 90 degrees left or
  right. The crucible also can't reverse direction; after entering each city block, it may only
  turn left, continue straight, or turn right.

  One way to minimize heat loss is this path:

      2>>34^>>>1323
      32v>>>35v5623
      32552456v>>54
      3446585845v52
      4546657867v>6
      14385987984v4
      44578769877v6
      36378779796v>
      465496798688v
      456467998645v
      12246868655<v
      25465488877v5
      43226746555v>

  This path never moves more than three consecutive blocks in the same direction and incurs
  a heat loss of only 102.

  Directing the crucible from the lava pool to the machine parts factory, but not moving more
  than three consecutive blocks in the same direction, what is the least heat loss it can incur?

  ## Part Two

  The crucibles of lava simply aren't large enough to provide an adequate supply of lava
  to the machine parts factory. Instead, the Elves are going to upgrade to ultra crucibles.

  Ultra crucibles are even more difficult to steer than normal crucibles. Not only do
  they have trouble going in a straight line, but they also have trouble turning!

  Once an ultra crucible starts moving in a direction, it needs to move a minimum of four
  blocks in that direction before it can turn (or even before it can stop at the end).
  However, it will eventually start to get wobbly: an ultra crucible can move a maximum
  of ten consecutive blocks without turning.

  In the above example, an ultra crucible could follow this path to minimize heat loss:

      2>>>>>>>>1323
      32154535v5623
      32552456v4254
      34465858v5452
      45466578v>>>>
      143859879845v
      445787698776v
      363787797965v
      465496798688v
      456467998645v
      122468686556v
      254654888773v
      432267465553v

  In the above example, an ultra crucible would incur the minimum possible heat loss of 94.

  Here's another example:

      111111111111
      999999999991
      999999999991
      999999999991
      999999999991

  Sadly, an ultra crucible would need to take an unfortunate path like this one:

      1>>>>>>>1111
      9999999v9991
      9999999v9991
      9999999v9991
      9999999v>>>>

  This route causes the ultra crucible to incur the minimum possible heat loss of 71.

  Directing the **ultra crucible** from the lava pool to the machine parts factory,
  **what is the least heat loss it can incur?**
  """

  defmodule Queue do
    @moduledoc "Simple implementation of priority queue based on Heap."

    defstruct [:queue]

    def new do
      %__MODULE__{
        queue: Heap.new(fn {a, _, _, _, _}, {b, _, _, _, _} -> a < b end)
      }
    end

    def enqueue(pqueue, elements) when is_list(elements) do
      Enum.reduce(elements, pqueue, fn e, q -> put(q, e) end)
    end

    def put(pqueue, element) do
      %{pqueue | queue: Heap.push(pqueue.queue, element)}
    end

    def pop(pqueue) do
      {element, queue} = Heap.split(pqueue.queue)
      {element, %{pqueue | queue: queue}}
    end
  end

  @doc "Return the least heat loss given min/max steps limit"
  def answer(input, min_steps \\ 1, max_steps \\ 999) do
    {grid, target} = parse_input(input)
    next = {0, 0, 0, nil, 0}
    queue = Queue.new()
    visited = MapSet.new()
    traverse(next, queue, visited, grid, {min_steps, max_steps}, target)
  end

  defp traverse({cost, x, y, _, _}, _, _, _, _, {x, y}), do: cost

  defp traverse({cost, x, y, dir, steps}, queue, visited, grid, bounds, target) do
    if MapSet.member?(visited, {x, y, dir, steps}) do
      {next, queue} = Queue.pop(queue)
      traverse(next, queue, visited, grid, bounds, target)
    else
      visited = MapSet.put(visited, {x, y, dir, steps})
      neighbouts = find_neighbours({cost, x, y, dir, steps}, grid, bounds, target)
      {next, queue} = Queue.enqueue(queue, neighbouts) |> Queue.pop()
      traverse(next, queue, visited, grid, bounds, target)
    end
  end

  defp find_neighbours(tile, grid, limits, target) do
    []
    |> move_straight(tile, target, limits, grid)
    |> turn(tile, target, limits, grid)
  end

  # Not moving yet, can't continue
  defp move_straight(acc, {_, _, _, nil, _}, _, _, _), do: acc

  # Max steps in one direction
  defp move_straight(acc, {_, _, _, _, steps}, _, {_, steps}, _), do: acc

  defp move_straight(acc, {cost, x, y, dir, steps}, target, _limits, grid) do
    maybe_add(acc, {cost, x, y, dir, steps}, 1, target, grid)
  end

  defp turn(acc, {cost, x, y, dir, _steps}, target, {min_steps, _}, grid) do
    case dir do
      :left -> [:up, :down]
      :right -> [:up, :down]
      :up -> [:left, :right]
      :down -> [:left, :right]
      nil -> [:down, :right]
    end
    |> Enum.reduce(acc, fn dir, acc ->
      maybe_add(acc, {cost, x, y, dir, 0}, min_steps, target, grid)
    end)
  end

  defp maybe_add(list, {cost, x, y, dir, steps}, ds, {mx, my}, grid) do
    {dx, dy} = dir_to_delta(dir)
    {xx, yy} = {x + dx * ds, y + dy * ds}
    in_bounds = xx >= 0 and xx <= mx and yy >= 0 and yy <= my

    if in_bounds do
      new_cost = calc_cost(cost, x, y, dx, dy, ds, grid)
      [{new_cost, xx, yy, dir, steps + ds} | list]
    else
      list
    end
  end

  defp calc_cost(cost, x, y, dx, dy, ds, grid) do
    Enum.reduce(1..ds, cost, fn i, acc -> acc + Map.get(grid, {x + dx * i, y + dy * i}) end)
  end

  defp dir_to_delta(dir) do
    case dir do
      :left -> {-1, 0}
      :right -> {1, 0}
      :up -> {0, -1}
      :down -> {0, 1}
    end
  end

  # --- Parser ---

  defp parse_input(input, loc \\ {0, 0}, acc \\ %{})
  defp parse_input("\n", {x, y}, acc), do: {acc, {x - 1, y}}
  defp parse_input("\n" <> rest, {_x, y}, acc), do: parse_input(rest, {0, y + 1}, acc)

  defp parse_input(<<ch::utf8, rest::binary>>, {x, y}, acc),
    do: parse_input(rest, {x + 1, y}, Map.put(acc, {x, y}, ch - ?0))
end
