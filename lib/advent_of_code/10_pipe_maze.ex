defmodule AdventOfCode.PipeMaze do
  @moduledoc ~S"""
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
  """

  @doc "Number of steps to the farthest point from the start"
  def answer(input) do
    map = parse_input(input)
    start = get_start_point(map)
    next = get_next_from_start(map, start)
    n = traverse(map, next, start, start, 1)
    div(n, 2)
  end

  # ---- Traverse ----

  defp traverse(_map, loc, _prev, dest, n) when loc == dest, do: n

  defp traverse(map, loc, prev, dest, n) do
    type = Map.get(map, loc)
    next = get_next(type, loc, prev)
    traverse(map, next, loc, dest, n + 1)
  end

  defp get_next(type, {x, y}, {px, py}) do
    case type do
      :down_right when y == py -> {x, y + 1}
      :down_right when x == px -> {x + 1, y}
      :left_down when y == py -> {x, y + 1}
      :left_down when x == px -> {x - 1, y}
      :left_right when x > px -> {x + 1, y}
      :left_right when x < px -> {x - 1, y}
      :left_up when y == py -> {x, y - 1}
      :left_up when x == px -> {x - 1, y}
      :up_down when y > py -> {x, y + 1}
      :up_down when y < py -> {x, y - 1}
      :up_right when x == px -> {x + 1, y}
      :up_right when y == py -> {x, y - 1}
    end
  end

  defp get_start_point(map), do: map |> Enum.find(fn {_k, v} -> v == :start end) |> elem(0)

  defp get_next_from_start(map, {x, y}) do
    up = Map.get(map, {x, y - 1})
    down = Map.get(map, {x, y + 1})
    left = Map.get(map, {x - 1, y})
    right = Map.get(map, {x + 1, y})

    cond do
      right in [:down_right, :left_right, :up_right] -> {x + 1, y}
      left in [:left_right, :left_down, :left_up] -> {x - 1, y}
      up in [:left_up, :up_right, :up_down] -> {x, y - 1}
      down in [:down_right, :left_down, :up_down] -> {x, y + 1}
      true -> raise("ERROR")
    end
  end

  # ---- Parser ----

  defp parse_input(input) do
    input
    |> String.split("", trim: true)
    |> do_parse_input({1, 1}, %{})
  end

  @node_types %{
    "S" => :start,
    "|" => :up_down,
    "L" => :up_right,
    "F" => :down_right,
    "-" => :left_right,
    "J" => :left_up,
    "7" => :left_down
  }

  defp do_parse_input([], _coords, acc), do: acc
  defp do_parse_input(["\n" | rest], {_x, y}, acc), do: do_parse_input(rest, {1, y + 1}, acc)
  defp do_parse_input(["." | rest], {x, y}, acc), do: do_parse_input(rest, {x + 1, y}, acc)

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

  # defp print_char(type) do
  #   case type do
  #     :start -> "S"
  #     :up_down -> "|"
  #     :up_right -> "└"
  #     :down_right -> "┌"
  #     :left_right -> "─"
  #     :left_up -> "┘"
  #     :left_down -> "┐"
  #   end
  # end
end
