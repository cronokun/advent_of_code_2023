defmodule AdventOfCode.PipeMaze do
  @moduledoc """
  # Day 10: Pipe Maze

  ## Part 1

  You use the hang glider to ride the hot air from Desert Island all the way up to
  the floating metal island. This island is surprisingly cold and there definitely
  aren't any thermals to glide on, so you leave your hang glider behind.

  You wander around for a while, but you don't find any people or animals. However,
  you do occasionally find signposts labeled "Hot Springs" pointing in a seemingly
  consistent direction; maybe you can find someone at the hot springs and ask them
  where the desert-machine parts are made.

  The landscape here is alien; even the flowers and trees are made of metal. As you
  stop to admire some metal grass, you notice something metallic scurry away in your
  peripheral vision and jump into a big pipe! It didn't look like any animal you've
  ever seen; if you want a better look, you'll need to get ahead of it.

  Scanning the area, you discover that the entire field you're standing on is densely
  packed with pipes; it was hard to tell at first because they're the same metallic
  silver color as the "ground". You make a quick sketch of all of the surface pipes
  you can see (your puzzle input).

  The pipes are arranged in a two-dimensional grid of tiles:

  - | is a vertical pipe connecting north and south.
  - - is a horizontal pipe connecting east and west.
  - L is a 90-degree bend connecting north and east.
  - J is a 90-degree bend connecting north and west.
  - 7 is a 90-degree bend connecting south and west.
  - F is a 90-degree bend connecting south and east.
  - . is ground; there is no pipe in this tile.
  - S is the starting position of the animal; there is a pipe on this tile,
    but your sketch doesn't show what shape the pipe has.

  Based on the acoustics of the animal's scurrying, you're confident the pipe that
  contains the animal is one large, continuous loop.

  For example, here is a square loop of pipe:

      .....
      .F-7.
      .|.|.
      .L-J.
      .....

  If the animal had entered this loop in the northwest corner, the sketch would
  instead look like this:

      .....
      .S-7.
      .|.|.
      .L-J.
      .....

  In the above diagram, the S tile is still a 90-degree F bend: you can tell because
  of how the adjacent pipes connect to it.

  Unfortunately, there are also many pipes that aren't connected to the loop! This
  sketch shows the same loop as above:

      -L|F7
      7S-7|
      L|7||
      -L-J|
      L|-JF

  In the above diagram, you can still figure out which pipes form the main loop:
  they're the ones connected to S, pipes those pipes connect to, pipes those pipes
  connect to, and so on. Every pipe in the main loop connects to its two neighbors
  (including S, which will have exactly two pipes connecting to it, and which is
  assumed to connect back to those two pipes).

  Here is a sketch that contains a slightly more complex main loop:

      ..F7.
      .FJ|.
      SJ.L7
      |F--J
      LJ...

  Here's the same example sketch with the extra, non-main-loop pipe tiles also shown:

      7-F7-
      .FJ|7
      SJLL7
      |F--J
      LJ.LJ

  If you want to get out ahead of the animal, you should find the tile in the loop
  that is farthest from the starting position. Because the animal is in the pipe,
  it doesn't make sense to measure this by direct distance. Instead, you need to
  find the tile that would take the longest number of steps along the loop to reach
  from the starting point - regardless of which way around the loop the animal went.

  In the first example with the square loop:

      .....
      .S-7.
      .|.|.
      .L-J.
      .....

  You can count the distance each tile in the loop is from the starting point like this:

      .....
      .012.
      .1.3.
      .234.
      .....

  In this example, the farthest point from the start is 4 steps away.

  Here's the more complex loop again:

      ..F7.
      .FJ|.
      SJ.L7
      |F--J
      LJ...

  Here are the distances for each tile on that loop:

      ..45.
      .236.
      01.78
      14567
      23...

  Find the single giant loop starting at S. How many steps along the loop does it take
  to get from the starting position to the point farthest from the starting position?


  ## Part Two

  You quickly reach the farthest point of the loop, but the animal never emerges.
  Maybe its nest is within the area enclosed by the loop?

  To determine whether it's even worth taking the time to search for such a nest,
  you should calculate how many tiles are contained within the loop. For example:

  ...........
  .S-------7.
  .|F-----7|.
  .||.....||.
  .||.....||.
  .|L-7.F-J|.
  .|..|.|..|.
  .L--J.L--J.
  ...........

  The above loop encloses merely four tiles - the two pairs of . in the southwest
  and southeast (marked I below). The middle . tiles (marked O below) are not in
  the loop. Here is the same loop again with those regions marked:

  ...........
  .S-------7.
  .|F-----7|.
  .||OOOOO||.
  .||OOOOO||.
  .|L-7OF-J|.
  .|II|O|II|.
  .L--JOL--J.
  .....O.....

  In fact, there doesn't even need to be a full tile path to the outside for tiles
  to count as outside the loop - squeezing between pipes is also allowed! Here, I is
  still within the loop and O is still outside the loop:

  ..........
  .S------7.
  .|F----7|.
  .||OOOO||.
  .||OOOO||.
  .|L-7F-J|.
  .|II||II|.
  .L--JL--J.
  ..........

  In both of the above examples, 4 tiles are enclosed by the loop.

  Here's a larger example:

  .F----7F7F7F7F-7....
  .|F--7||||||||FJ....
  .||.FJ||||||||L7....
  FJL7L7LJLJ||LJ.L-7..
  L--J.L7...LJS7F-7L7.
  ....F-J..F7FJ|L7L7L7
  ....L7.F7||L7|.L7L7|
  .....|FJLJ|FJ|F7|.LJ
  ....FJL-7.||.||||...
  ....L---J.LJ.LJLJ...

  The above sketch has many random bits of ground, some of which are in the loop (I)
  and some of which are outside it (O):

  OF----7F7F7F7F-7OOOO
  O|F--7||||||||FJOOOO
  O||OFJ||||||||L7OOOO
  FJL7L7LJLJ||LJIL-7OO
  L--JOL7IIILJS7F-7L7O
  OOOOF-JIIF7FJ|L7L7L7
  OOOOL7IF7||L7|IL7L7|
  OOOOO|FJLJ|FJ|F7|OLJ
  OOOOFJL-7O||O||||OOO
  OOOOL---JOLJOLJLJOOO

  In this larger example, 8 tiles are enclosed by the loop.

  Any tile that isn't part of the main loop can count as being enclosed by the loop.
  Here's another example with many bits of junk pipe lying around that aren't connected
  to the main loop at all:

  FF7FSF7F7F7F7F7F---7
  L|LJ||||||||||||F--J
  FL-7LJLJ||||||LJL-77
  F--JF--7||LJLJ7F7FJ-
  L---JF-JLJ.||-FJLJJ7
  |F|F-JF---7F7-L7L|7|
  |FFJF7L7F-JF7|JL---7
  7-L-JL7||F7|L7F-7F7|
  L.L7LFJ|||||FJL7||LJ
  L7JLJL-JLJLJL--JLJ.L

  Here are just the tiles that are enclosed by the loop marked with I:

  FF7FSF7F7F7F7F7F---7
  L|LJ||||||||||||F--J
  FL-7LJLJ||||||LJL-77
  F--JF--7||LJLJIF7FJ-
  L---JF-JLJIIIIFJLJJ7
  |F|F-JF---7IIIL7L|7|
  |FFJF7L7F-JF7IIL---7
  7-L-JL7||F7|L7F-7F7|
  L.L7LFJ|||||FJL7||LJ
  L7JLJL-JLJLJL--JLJ.L

  In this last example, 10 tiles are enclosed by the loop.

  Figure out whether you have time to search for the nest by calculating the area
  within the loop. **How many tiles are enclosed by the loop?**
  """

  @doc "Number of steps to the farthest point from the start"
  def answer(input) do
    {maze, start} = parse_input(input)
    loop = find_loop(maze, start)
    div(length(loop), 2)
  end

  defp find_loop(maze, start) do
    traverse(maze, start, start, start, [])
  end

  @doc "Number of tiles that are enclosed by the loop"
  def final_answer(input) do
    {maze, start} = parse_input(input)
    loop = find_loop(maze, start) |> Map.new()
    count_tiles(maze, loop)
  end

  defp count_tiles(maze, loop) do
    maze
    |> replace_blank_pipes(loop)
    |> count_by_row()
    |> Enum.sum()
  end

  # ---- Traverse ----

  defp traverse(_maze, cur, _prev, dest, acc) when cur == dest and acc != [],
    do: Enum.reverse(acc)

  defp traverse(maze, cur, prev, dest, acc) do
    next = get_next_cell(maze, cur, prev)
    traverse(maze, next, cur, dest, [cur | acc])
  end

  # credo:disable-for-lines:20
  defp find_start_cell(maze) do
    {loc, _} = Enum.find(maze, fn {_k, v} -> v == :start end)

    up = Map.get(maze, go_up(loc))
    down = Map.get(maze, go_down(loc))
    left = Map.get(maze, go_left(loc))
    right = Map.get(maze, go_right(loc))

    type =
      cond do
        connected_to_right?(left) and connected_to_left?(right) -> :left_right
        connected_to_up?(down) and connected_to_down?(up) -> :up_down
        connected_to_right?(left) and connected_to_down?(up) -> :left_up
        connected_to_right?(left) and connected_to_up?(down) -> :left_down
        connected_to_left?(right) and connected_to_down?(up) -> :right_up
        connected_to_left?(right) and connected_to_up?(down) -> :right_down
      end

    {loc, type}
  end

  # credo:disable-for-lines:20
  defp get_next_cell(maze, {{x, y} = loc, type}, {{px, py}, _prev_type}) do
    next =
      case type do
        :right_down when y == py -> go_down(loc)
        :right_down when x == px -> go_right(loc)
        :left_down when y == py -> go_down(loc)
        :left_down when x == px -> go_left(loc)
        :left_right when x > px -> go_right(loc)
        :left_right when x < px -> go_left(loc)
        :left_up when y == py -> go_up(loc)
        :left_up when x == px -> go_left(loc)
        :up_down when y > py -> go_down(loc)
        :up_down when y < py -> go_up(loc)
        :right_up when x == px -> go_right(loc)
        :right_up when y == py -> go_up(loc)
      end

    next_type = Map.get(maze, next)
    {next, next_type}
  end

  # ---- Count enclosed -----

  defp replace_blank_pipes(maze, loop) do
    Enum.map(maze, fn {loc, val} ->
      if Map.has_key?(loop, loc), do: {loc, val}, else: {loc, :blank}
    end)
  end

  defp count_by_row(maze) do
    maze
    |> Enum.sort()
    |> Enum.group_by(fn {{_x, y}, _val} -> y end, fn {_loc, val} -> val end)
    |> Enum.map(fn {_row, cells} -> scanline(cells, :blank, :outside, 0) end)
  end

  defp scanline([], _prev, _mode, acc), do: acc

  defp scanline([:blank | rest], _prev, :inside, acc) do
    scanline(rest, :blank, :inside, acc + 1)
  end

  defp scanline([:blank | rest], _prev, :outside, acc) do
    scanline(rest, :blank, :outside, acc)
  end

  defp scanline([val | rest], prev, mode, acc) do
    next_mode = maybe_swap_mode(val, prev, mode)
    next_prev = if val == :left_right, do: prev, else: val

    scanline(rest, next_prev, next_mode, acc)
  end

  defp maybe_swap_mode(:left_up, :right_up, mode), do: mode
  defp maybe_swap_mode(:right_down, :left_down, mode), do: mode
  defp maybe_swap_mode(:left_right, _prev, mode), do: mode
  defp maybe_swap_mode(:up_down, _prev, mode), do: swap_mode(mode)
  defp maybe_swap_mode(:left_up, :right_down, mode), do: swap_mode(mode)
  defp maybe_swap_mode(:left_down, :right_up, mode), do: swap_mode(mode)
  defp maybe_swap_mode(_cur, _prev, mode), do: mode

  defp swap_mode(:inside), do: :outside
  defp swap_mode(:outside), do: :inside

  # ---- Utils -----

  defp connected_to_left?(type), do: type in [:left_right, :left_up, :left_down]
  defp connected_to_right?(type), do: type in [:left_right, :right_up, :right_down]
  defp connected_to_up?(type), do: type in [:up_down, :right_up, :left_up]
  defp connected_to_down?(type), do: type in [:up_down, :left_down, :right_down]

  defp go_up({x, y}), do: {x, y - 1}
  defp go_down({x, y}), do: {x, y + 1}
  defp go_left({x, y}), do: {x - 1, y}
  defp go_right({x, y}), do: {x + 1, y}

  # ---- Parser ----

  defp parse_input(input) do
    maze =
      input
      |> String.split("", trim: true)
      |> do_parse_input({1, 1}, %{})

    {loc, val} = find_start_cell(maze)

    {
      Map.put(maze, loc, val),
      {loc, val}
    }
  end

  @node_types %{
    "S" => :start,
    "|" => :up_down,
    "L" => :right_up,
    "F" => :right_down,
    "-" => :left_right,
    "J" => :left_up,
    "7" => :left_down,
    "." => :blank
  }

  defp do_parse_input([], _coords, acc), do: acc
  defp do_parse_input(["\n" | rest], {_x, y}, acc), do: do_parse_input(rest, {1, y + 1}, acc)
  # defp do_parse_input(["." | rest], {x, y}, acc), do: do_parse_input(rest, {x + 1, y}, acc)

  defp do_parse_input([t | rest], {x, y}, acc) do
    type = Map.get(@node_types, t)
    acc = Map.put(acc, {x, y}, type)
    do_parse_input(rest, {x + 1, y}, acc)
  end

  def print(input) do
    IO.puts(["\n", convert_char(input, [])])
  end

  defp convert_char(<<>>, acc), do: Enum.reverse(acc)
  defp convert_char(<<"\n", rest::binary>>, acc), do: convert_char(rest, ["\n" | acc])
  defp convert_char(<<".", rest::binary>>, acc), do: convert_char(rest, ["." | acc])
  defp convert_char(<<"S", rest::binary>>, acc), do: convert_char(rest, ["S" | acc])
  defp convert_char(<<"|", rest::binary>>, acc), do: convert_char(rest, ["│" | acc])
  defp convert_char(<<"-", rest::binary>>, acc), do: convert_char(rest, ["─" | acc])
  defp convert_char(<<"L", rest::binary>>, acc), do: convert_char(rest, ["└" | acc])
  defp convert_char(<<"J", rest::binary>>, acc), do: convert_char(rest, ["┘" | acc])
  defp convert_char(<<"7", rest::binary>>, acc), do: convert_char(rest, ["┐" | acc])
  defp convert_char(<<"F", rest::binary>>, acc), do: convert_char(rest, ["┌" | acc])
  defp convert_char(<<char, rest::binary>>, acc), do: convert_char(rest, [char | acc])
end
