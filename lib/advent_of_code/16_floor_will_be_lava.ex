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
    {map, mx, my} = parse_input(input)
    map = get_rows_and_columns(map)

    map
    |> traverse(0, 0, :right, mx, my, MapSet.new(), MapSet.new())
    |> calc_energized()
  end

  defp calc_energized({list, _visited}), do: MapSet.size(list)

  defp traverse(map, x, y, dir, mx, my, acc, memo) do
    type = Map.get(map.tiles, {x, y}, :blank)

    find_next_dir(type, dir)
    |> Enum.reduce({acc, memo}, fn ndir, {a, m} ->
      traverse_next(map, x, y, ndir, mx, my, a, m)
    end)
  end

  defp traverse_next(map, x, y, dir, mx, my, acc, memo) do
    case find_next_tile(map, x, y, dir) do
      {nx, ny} ->
        type = Map.get(map.tiles, {nx, ny})
        if loop?(memo, nx, ny, dir, type) do
          {add_energized(acc, nx, ny, x, y), memo}
        else
          acc = add_energized(acc, nx, ny, x, y)
          memo = add_visited(memo, nx, ny, dir)
          traverse(map, nx, ny, dir, mx, my, acc, memo)
        end

      nil ->
        {nx, ny} =
          case dir do
            :left -> {0, y}
            :right -> {mx, y}
            :up -> {x, 0}
            :down -> {x, my}
          end

        {add_energized(acc, nx, ny, x, y), memo}
    end
  end

  defp find_next_dir(:blank, dir), do: [dir]
  defp find_next_dir(:mirror, :down), do: [:left]
  defp find_next_dir(:mirror, :left), do: [:down]
  defp find_next_dir(:mirror, :right), do: [:up]
  defp find_next_dir(:mirror, :up), do: [:right]
  defp find_next_dir(:back_mirror, :down), do: [:right]
  defp find_next_dir(:back_mirror, :left), do: [:up]
  defp find_next_dir(:back_mirror, :right), do: [:down]
  defp find_next_dir(:back_mirror, :up), do: [:left]
  defp find_next_dir(:horz_split, :down), do: [:down]
  defp find_next_dir(:horz_split, :left), do: [:up, :down]
  defp find_next_dir(:horz_split, :right), do: [:up, :down]
  defp find_next_dir(:horz_split, :up), do: [:up]
  defp find_next_dir(:vert_split, :down), do: [:left, :right]
  defp find_next_dir(:vert_split, :left), do: [:left]
  defp find_next_dir(:vert_split, :right), do: [:right]
  defp find_next_dir(:vert_split, :up), do: [:left, :right]

  defp find_next_tile(map, x, y, :left) do
    Map.get(map.lines, y, [])
    |> Enum.reverse()
    |> Enum.drop_while(&(&1 >= x))
    |> case do
      [] -> nil
      [nx | _] -> {nx, y}
    end
  end

  defp find_next_tile(map, x, y, :right) do
    Map.get(map.lines, y, [])
    |> Enum.drop_while(&(&1 <= x))
    |> case do
      [] -> nil
      [nx | _] -> {nx, y}
    end
  end

  defp find_next_tile(map, x, y, :up) do
    Map.get(map.columns, x, [])
    |> Enum.reverse()
    |> Enum.drop_while(&(&1 >= y))
    |> case do
      [] -> nil
      [ny | _] -> {x, ny}
    end
  end

  defp find_next_tile(map, x, y, :down) do
    Map.get(map.columns, x, [])
    |> Enum.drop_while(&(&1 <= y))
    |> case do
      [] -> nil
      [ny | _] -> {x, ny}
    end
  end

  defp loop?(memo, x, y, :left, :horz_split), do: MapSet.member?(memo, {x, y, :right})
  defp loop?(memo, x, y, :right, :horz_split), do: MapSet.member?(memo, {x, y, :left})
  defp loop?(memo, x, y, :up, :vert_split), do: MapSet.member?(memo, {x, y, :down})
  defp loop?(memo, x, y, :down, :vert_split), do: MapSet.member?(memo, {x, y, :up})
  defp loop?(memo, x, y, dir, _type), do: MapSet.member?(memo, {x, y, dir})

  defp add_energized(tiles, nx, ny, px, py) do
    for i <- px..nx, j <- py..ny, reduce: tiles, do: (acc -> MapSet.put(acc, {i, j}))
  end

  defp add_visited(visited, x, y, dir) do
    MapSet.put(visited, {x, y, dir})
  end

  # ----  Part 2  --------

  @doc "Maximum energized tiles count"
  def final_answer(input) do
    {map, mx, my} = parse_input(input)
    map = get_rows_and_columns(map)

    all_start_positions(mx, my)
    |> Enum.reduce(0, fn {x, y, dir}, result ->
      total =
        traverse(map, x, y, dir, mx, my, MapSet.new(), MapSet.new())
        |> calc_energized()

      max(total, result)
    end)
  end

  defp all_start_positions(x, y),
    do: left_side(0, y) ++ right_side(x, y) ++ top_side(x, 0) ++ bottom_side(x, y)

  defp left_side(0, my), do: Enum.map(0..my, fn y -> {0, y, :right} end)
  defp right_side(mx, my), do: Enum.map(0..my, fn y -> {mx, y, :left} end)
  defp top_side(mx, 0), do: Enum.map(0..mx, fn x -> {x, 0, :down} end)
  defp bottom_side(mx, my), do: Enum.map(0..mx, fn x -> {x, my, :up} end)

  # ----  Parser  --------

  defp parse_input(input, acc \\ %{}, x \\ 0, y \\ 0)
  defp parse_input("\n", acc, x, y), do: {acc, x - 1, y}
  defp parse_input("\n" <> rest, acc, _x, y), do: parse_input(rest, acc, 0, y + 1)
  defp parse_input("." <> rest, acc, x, y), do: parse_input(rest, acc, x + 1, y)

  defp parse_input("|" <> rest, acc, x, y),
    do: parse_input(rest, Map.put(acc, {x, y}, :horz_split), x + 1, y)

  defp parse_input("-" <> rest, acc, x, y),
    do: parse_input(rest, Map.put(acc, {x, y}, :vert_split), x + 1, y)

  defp parse_input("/" <> rest, acc, x, y),
    do: parse_input(rest, Map.put(acc, {x, y}, :mirror), x + 1, y)

  defp parse_input("\\" <> rest, acc, x, y),
    do: parse_input(rest, Map.put(acc, {x, y}, :back_mirror), x + 1, y)

  defp get_rows_and_columns(map) do
    smap = Enum.sort(map)

    %{
      lines: Enum.group_by(smap, fn {{_, y}, _} -> y end, fn {{x, _}, _} -> x end),
      columns: Enum.group_by(smap, fn {{x, _}, _} -> x end, fn {{_, y}, _} -> y end),
      tiles: map
    }
  end
end
