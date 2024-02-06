defmodule AdventOfCode.FloorWillBeLava do
  @moduledoc ~S"""
  # Day 16: The Floor Will Be Lava

  With the beam of light completely focused somewhere, the reindeer leads you deeper still into
  the Lava Production Facility. At some point, you realize that the steel facility walls have
  been replaced with cave, and the doorways are just cave, and the floor is cave, and you're
  pretty sure this is actually just a giant cave.

  Finally, as you approach what must be the heart of the mountain, you see a bright light in
  a cavern up ahead. There, you discover that the beam of light you so carefully focused is
  emerging from the cavern wall closest to the facility and pouring all of its energy into a
  contraption on the opposite side.

  Upon closer inspection, the contraption appears to be a flat, two-dimensional square grid
  containing empty space (.), mirrors (/ and \), and splitters (| and -).

  The contraption is aligned so that most of the beam bounces around the grid, but each tile on
  the grid converts some of the beam's light into heat to melt the rock in the cavern.

  You note the layout of the contraption (your puzzle input). For example:

      .|...\....
      |.-.\.....
      .....|-...
      ........|.
      ..........
      .........\
      ..../.\\..
      .-.-/..|..
      .|....-|.\
      ..//.|....

  The beam enters in the top-left corner from the left and heading to the right. Then, it's
  behavior depends on what it encounters as it moves:

  - If the beam encounters empty space (.), it continues in the same direction.

  - If the beam encounters a mirror (/ or \), the beam is reflected 90 degrees depending on the
    angle of the mirror. For instance, a rightward-moving beam that encounters a / mirror would
    continue upward in the mirror's column, while a rightward-moving beam that encounters
    a \ mirror would continue downward from the mirror's column.

  - If the beam encounters the pointy end of a splitter (| or -), the beam passes through the
    splitter as if the splitter were empty space. For instance, a rightward-moving beam that
    encounters a - splitter would continue in the same direction.

  - If the beam encounters the flat side of a splitter (| or -), the beam is split into two beams
    going in each of the two directions the splitter's pointy ends are pointing. For instance,
    a rightward-moving beam that encounters a | splitter would split into two beams: one that
    continues upward from the splitter's column and one that continues downward from the
    splitter's column.

  Beams do not interact with other beams; a tile can have many beams passing through it at
  the same time. A tile is energized if that tile has at least one beam pass through it, reflect
  in it, or split in it.

  In the above example, here is how the beam of light bounces around the contraption:

      >|<<<\....
      |v-.\^....
      .v...|->>>
      .v...v^.|.
      .v...v^...
      .v...v^..\
      .v../2\\..
      <->-/vv|..
      .|<<<2-|.\
      .v//.|.v..

  Beams are only shown on empty tiles; arrows indicate the direction of the beams. If a tile
  contains beams moving in multiple directions, the number of distinct directions is shown
  instead. Here is the same diagram but instead only showing whether a tile is energized (#)
  or not (.):

      ######....
      .#...#....
      .#...#####
      .#...##...
      .#...##...
      .#...##...
      .#..####..
      ########..
      .#######..
      .#...#.#..

  Ultimately, in this example, 46 tiles become energized.

  The light isn't energizing enough tiles to produce lava; to debug the contraption, you need
  to start by analyzing the current situation. With the beam starting in the top-left heading
  right, **how many tiles end up being energized?**

  ## --- Part 2 ---

  As you try to work out what might be wrong, the reindeer tugs on your shirt and leads you to
  a nearby control panel. There, a collection of buttons lets you align the contraption so that
  the beam enters from any edge tile and heading away from that edge. (You can choose either of
  two directions for the beam if it starts on a corner; for instance, if the beam starts in the
  bottom-right corner, it can start heading either left or upward.)

  So, the beam could start on any tile in the top row (heading downward), any tile in the bottom
  row (heading upward), any tile in the leftmost column (heading right), or any tile in the
  rightmost column (heading left). To produce lava, you need to find the configuration that
  energizes as many tiles as possible.

  In the above example, this can be achieved by starting the beam in the fourth tile from the
  left in the top row:

      .|<2<\....
      |v-v\^....
      .v.v.|->>>
      .v.v.v^.|.
      .v.v.v^...
      .v.v.v^..\
      .v.v/2\\..
      <-2-/vv|..
      .|<<<2-|.\
      .v//.|.v..

  Using this configuration, 51 tiles are energized:

      .#####....
      .#.#.#....
      .#.#.#####
      .#.#.##...
      .#.#.##...
      .#.#.##...
      .#.#####..
      ########..
      .#######..
      .#...#.#..

  Find the initial beam configuration that energizes the largest number of tiles; how many tiles
  are energized in that configuration?
  """

  @doc "How many tiles are energized"
  def answer(input) do
    input
    |> parse_input()
    |> traverse()
    |> elem(0)
    |> count_energized_tiles()
  end

  defp traverse(map, start \\ {{0, 0}, :right}, acc \\ [], memo \\ MapSet.new())

  defp traverse(map, {loc, _dir} = tile, acc, memo) do
    type = Map.get(map, loc)

    if is_nil(type) or already_visited?(memo, tile) do
      {acc, memo}
    else
      {acc, memo} = put_tile(acc, memo, tile)
      traverse_next(map, tile, type, acc, memo)
    end
  end

  defp traverse_next(map, {loc, dir}, :empty, acc, memo),
    do: traverse(map, next(loc, dir), acc, memo)

  defp traverse_next(map, {loc, :right}, :back_mirror, acc, memo),
    do: traverse(map, next(loc, :down), acc, memo)

  defp traverse_next(map, {loc, :left}, :back_mirror, acc, memo),
    do: traverse(map, next(loc, :up), acc, memo)

  defp traverse_next(map, {loc, :up}, :back_mirror, acc, memo),
    do: traverse(map, next(loc, :left), acc, memo)

  defp traverse_next(map, {loc, :down}, :back_mirror, acc, memo),
    do: traverse(map, next(loc, :right), acc, memo)

  defp traverse_next(map, {loc, :right}, :mirror, acc, memo),
    do: traverse(map, next(loc, :up), acc, memo)

  defp traverse_next(map, {loc, :left}, :mirror, acc, memo),
    do: traverse(map, next(loc, :down), acc, memo)

  defp traverse_next(map, {loc, :up}, :mirror, acc, memo),
    do: traverse(map, next(loc, :right), acc, memo)

  defp traverse_next(map, {loc, :down}, :mirror, acc, memo),
    do: traverse(map, next(loc, :left), acc, memo)

  defp traverse_next(map, {loc, dir}, :horizontal_split, acc, memo) when dir in [:up, :down] do
    {acc, memo} = traverse(map, next(loc, :left), acc, memo)
    traverse(map, next(loc, :right), acc, memo)
  end

  defp traverse_next(map, {loc, dir}, :vertical_split, acc, memo) when dir in [:left, :right] do
    {acc, memo} = traverse(map, next(loc, :up), acc, memo)
    traverse(map, next(loc, :down), acc, memo)
  end

  defp traverse_next(map, {loc, dir}, _type, acc, memo),
    do: traverse(map, next(loc, dir), acc, memo)

  defp next({x, y}, :down), do: {{x, y + 1}, :down}
  defp next({x, y}, :left), do: {{x - 1, y}, :left}
  defp next({x, y}, :right), do: {{x + 1, y}, :right}
  defp next({x, y}, :up), do: {{x, y - 1}, :up}

  defp put_tile(acc, memo, tile), do: {[tile | acc], MapSet.put(memo, hash(tile))}

  defp already_visited?(memo, tile), do: MapSet.member?(memo, hash(tile))

  defp hash({{x, y}, dir}) do
    d =
      case dir do
        :left -> 0
        :right -> 1
        :up -> 2
        :down -> 3
      end

    <<x::8, y::8, d::2>>
  end

  defp count_energized_tiles(list) do
    list
    |> Enum.map(&elem(&1, 0))
    |> Enum.uniq()
    |> Enum.count()
  end

  # --- Part 2 ---

  @doc "Maximum energized tiles count"
  def final_answer(input) do
    map = parse_input(input)

    map
    |> all_start_positions()
    |> Enum.reduce(0, fn start, result ->
      {acc, _memo} = traverse(map, start, [], MapSet.new())
      max(count_energized_tiles(acc), result)
    end)
  end

  defp all_start_positions(map) do
    {x, y} = map |> Map.keys() |> Enum.max()
    left_side(0, y) ++ right_side(x, y) ++ top_side(x, 0) ++ bottom_side(x, y)
  end

  defp left_side(0, max_y), do: Enum.map(0..max_y, fn y -> {{0, y}, :right} end)
  defp right_side(max_x, max_y), do: Enum.map(0..max_y, fn y -> {{max_x, y}, :left} end)
  defp top_side(max_x, 0), do: Enum.map(0..max_x, fn x -> {{x, 0}, :down} end)
  defp bottom_side(max_x, max_y), do: Enum.map(0..max_x, fn x -> {{x, max_y}, :up} end)

  # --- Parser ---

  defp parse_input(input, loc \\ {0, 0}, acc \\ %{})
  defp parse_input("", _, acc), do: acc
  defp parse_input("\n" <> rest, {_x, y}, acc), do: parse_input(rest, {0, y + 1}, acc)

  defp parse_input("." <> rest, {x, y}, acc),
    do: parse_input(rest, {x + 1, y}, Map.put(acc, {x, y}, :empty))

  defp parse_input("\\" <> rest, {x, y}, acc),
    do: parse_input(rest, {x + 1, y}, Map.put(acc, {x, y}, :back_mirror))

  defp parse_input("/" <> rest, {x, y}, acc),
    do: parse_input(rest, {x + 1, y}, Map.put(acc, {x, y}, :mirror))

  defp parse_input("-" <> rest, {x, y}, acc),
    do: parse_input(rest, {x + 1, y}, Map.put(acc, {x, y}, :horizontal_split))

  defp parse_input("|" <> rest, {x, y}, acc),
    do: parse_input(rest, {x + 1, y}, Map.put(acc, {x, y}, :vertical_split))
end
