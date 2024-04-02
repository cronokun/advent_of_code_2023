defmodule AdventOfCode.ClumsyCrucible do
  @moduledoc ~S"""
  # Day 17: Clumsy Crucible

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
  """

  defmodule Queue do
    @moduledoc "Simple implementation of priority queue based on :gb_sets."

    defstruct [:set]

    def new, do: %__MODULE__{set: :gb_sets.new()}

    def enqueue(queue, elements) when is_list(elements) do
      Enum.reduce(elements, queue, fn e, q -> put(q, e) end)
    end

    def put(queue, element) do
      set = :gb_sets.add(element, queue.set)
      %{queue | set: set}
    end

    def pop(queue) do
      {element, set} = :gb_sets.take_smallest(queue.set)
      {element, %{queue | set: set}}
    end
  end

  @doc "Return the least heat loss"
  def answer(input) do
    {grid, target} = parse_input(input)
    next = {0, 0, 0, 0, 0, 0}
    queue = Queue.new()
    visited = MapSet.new()
    find_min_cost(next, queue, visited, grid, target)
  end

  defp find_min_cost({cost, x, y, _, _, _}, _, _, _, {x, y}), do: cost

  defp find_min_cost({cost, x, y, dx, dy, steps}, queue, visited, grid, target) do
    {neighbours, visited} =
      if MapSet.member?(visited, {x, y, dx, dy, steps}) do
        {[], visited}
      else
        add_neighbours({cost, x, y, dx, dy, steps}, visited, grid, target)
      end

    {next, queue} = queue |> Queue.enqueue(neighbours) |> Queue.pop()
    find_min_cost(next, queue, visited, grid, target)
  end

  defp add_neighbours({cost, x, y, dx, dy, steps}, visited, grid, target) do
    visited = MapSet.put(visited, {x, y, dx, dy, steps})
    next = maybe_add([], {cost, x + dx, y + dy, dx, dy, steps + 1}, {0, 0}, target, grid)

    next =
      [{1, 0}, {-1, 0}, {0, 1}, {0, -1}]
      |> Enum.reduce(next, fn {xx, yy}, acc ->
        maybe_add(acc, {cost, x + xx, y + yy, xx, yy, 1}, {dx, dy}, target, grid)
      end)

    {next, visited}
  end

  defguard out_of_bounds(x, y, mx, my) when x < 0 or x > mx or y < 0 or y > my
  defguard is_same_dir(dx, dy, px, py) when {dx, dy} == {px, py} or {dx, dy} == {-px, -py}

  defp maybe_add(list, {_cost, x, y, dx, dy, steps}, {px, py}, {mx, my}, _grid)
       when steps > 3 or {dx, dy} == {0, 0} or out_of_bounds(x, y, mx, my) or
              is_same_dir(dx, dy, px, py),
       do: list

  defp maybe_add(list, {cost, x, y, dx, dy, steps}, _, _, grid) do
    new_cost = cost + Map.get(grid, {x, y})
    [{new_cost, x, y, dx, dy, steps} | list]
  end

  # --- Parser ---

  defp parse_input(input, loc \\ {0, 0}, acc \\ [])
  defp parse_input("\n", {x, y}, acc), do: {Map.new(acc), {x - 1, y}}
  defp parse_input("\n" <> rest, {_x, y}, acc), do: parse_input(rest, {0, y + 1}, acc)

  defp parse_input(<<ch::utf8, rest::binary>>, {x, y}, acc),
    do: parse_input(rest, {x + 1, y}, [{{x, y}, ch - ?0} | acc])
end
