defmodule AdventOfCode.ParabolicReflectorDish do
  @moduledoc """
  # Day 14: Parabolic Reflector Dish

  ## --- Part 1 ----

  You reach the place where all of the mirrors were pointing: a massive parabolic
  reflector dish attached to the side of another large mountain.

  The dish is made up of many small mirrors, but while the mirrors themselves are
  roughly in the shape of a parabolic reflector dish, each individual mirror seems
  to be pointing in slightly the wrong direction. If the dish is meant to focus light,
  all it's doing right now is sending it in a vague direction.

  This system must be what provides the energy for the lava! If you focus the reflector
  dish, maybe you can go where it's pointing and use the light to fix the lava production.

  Upon closer inspection, the individual mirrors each appear to be connected via an
  elaborate system of ropes and pulleys to a large metal platform below the dish.
  The platform is covered in large rocks of various shapes. Depending on their position,
  the weight of the rocks deforms the platform, and the shape of the platform controls
  which ropes move and ultimately the focus of the dish.

  In short: if you move the rocks, you can focus the dish. The platform even has
  a control panel on the side that lets you tilt it in one of four directions!
  The rounded rocks (O) will roll when the platform is tilted, while the cube-shaped
  rocks (#) will stay in place. You note the positions of all of the empty spaces (.)
  and rocks (your puzzle input). For example:

    O....#....
    O.OO#....#
    .....##...
    OO.#O....O
    .O.....O#.
    O.#..O.#.#
    ..O..#O..O
    .......O..
    #....###..
    #OO..#....

  Start by tilting the lever so all of the rocks will slide north as far as they will go:

    OOOO.#.O..
    OO..#....#
    OO..O##..O
    O..#.OO...
    ........#.
    ..#....#.#
    ..O..#.O.O
    ..O.......
    #....###..
    #....#....

  You notice that the support beams along the north side of the platform are damaged;
  to ensure the platform doesn't collapse, you should calculate the total load on the
  north support beams.

  The amount of load caused by a single rounded rock (O) is equal to the number of rows
  from the rock to the south edge of the platform, including the row the rock is on.
  (Cube-shaped rocks (#) don't contribute to load.) So, the amount of load caused by
  each rock in each row is as follows:

    OOOO.#.O.. 10
    OO..#....#  9
    OO..O##..O  8
    O..#.OO...  7
    ........#.  6
    ..#....#.#  5
    ..O..#.O.O  4
    ..O.......  3
    #....###..  2
    #....#....  1

  The total load is the sum of the load caused by all of the rounded rocks. In this
  example, the total load is 136.

  Tilt the platform so that the rounded rocks all roll north. Afterward, **what is
  the total load on the north support beams?**

  ## --- Part 2 ---

  The parabolic reflector dish deforms, but not in a way that focuses the beam.
  To do that, you'll need to move the rocks to the edges of the platform. Fortunately,
  a button on the side of the control panel labeled "spin cycle" attempts to do just that!

  Each cycle tilts the platform four times so that the rounded rocks roll north, then
  west, then south, then east. After each tilt, the rounded rocks roll as far as they
  can before the platform tilts in the next direction. After one cycle, the platform
  will have finished rolling the rounded rocks in those four directions in that order.

  Here's what happens in the example above after each of the first few cycles:

  After 1 cycle:

    .....#....
    ....#...O#
    ...OO##...
    .OO#......
    .....OOO#.
    .O#...O#.#
    ....O#....
    ......OOOO
    #...O###..
    #..OO#....

  After 2 cycles:

    .....#....
    ....#...O#
    .....##...
    ..O#......
    .....OOO#.
    .O#...O#.#
    ....O#...O
    .......OOO
    #..OO###..
    #.OOO#...O

  After 3 cycles:

    .....#....
    ....#...O#
    .....##...
    ..O#......
    .....OOO#.
    .O#...O#.#
    ....O#...O
    .......OOO
    #...O###.O
    #.OOO#...O

  This process should work if you leave it running long enough, but you're still worried
  about the north support beams. To make sure they'll survive for a while, you need
  to calculate the total load on the north support beams after 1000000000 cycles.

  In the above example, after 1000000000 cycles, the total load on the north support
  beams is 64.

  Run the spin cycle for 1000000000 cycles. Afterward, **what is the total load on
  the north support beams?**
  """

  @doc "Total load on the north support beams"
  def answer(input) do
    input
    |> parse_input()
    |> tilt_north()
    |> calculate_load()
  end

  @doc "Total load on the north support beams after N spin cycles"
  def final_answer(input, n) do
    with grid <- parse_input(input),
         {grid, loop} <- detect_loop(grid),
         n <- calc_cycles_left(n, loop) do
      grid |> spin_n_times(n) |> calculate_load()
    end
  end

  # --- Tilt platform ---

  defp tilt(grid), do: Enum.map(grid, &tilt_line/1)

  defp tilt_line(list, tmp \\ [], acc \\ [])
  defp tilt_line([], tmp, acc), do: acc ++ tmp
  defp tilt_line(["O" | rest], tmp, acc), do: tilt_line(rest, tmp, acc ++ ["O"])
  defp tilt_line(["#" | rest], tmp, acc), do: tilt_line(rest, [], acc ++ tmp ++ ["#"])
  defp tilt_line(["." | rest], tmp, acc), do: tilt_line(rest, tmp ++ ["."], acc)

  defp calculate_load(grid), do: calculate_load(Enum.reverse(grid), 1, 0)
  defp calculate_load([], _lnum, total), do: total

  defp calculate_load([line | rest], lnum, total),
    do: calculate_load(rest, lnum + 1, total + line_load(line) * lnum)

  defp line_load(line), do: Enum.count(line, &(&1 == "O"))

  # --- Spin cycle ---

  defp tilt_north(grid), do: grid |> flip() |> tilt() |> flip()

  defp tilt_west(grid), do: tilt(grid)

  defp tilt_south(grid), do: grid |> flip_and_reverse() |> tilt() |> reverse_and_flip()

  defp tilt_east(grid), do: grid |> reverse() |> tilt() |> reverse()

  defp spin_n_times(grid, n),
    do: for(i <- 0..n, i > 0, reduce: grid, do: (g -> run_spin_cycle(g)))

  defp run_spin_cycle(grid),
    do: grid |> tilt_north() |> tilt_west() |> tilt_south() |> tilt_east()

  # --- Loop detection ---

  defp detect_loop(grid, loop \\ []) do
    hash = grid_hash(grid)

    if Enum.member?(loop, hash) do
      {grid, loop_offset_and_length(loop, hash)}
    else
      detect_loop(run_spin_cycle(grid), [hash | loop])
    end
  end

  defp loop_offset_and_length(loop, start) do
    loop_len = Enum.find_index(loop, &(&1 == start)) + 1
    loop_offset = length(loop) - loop_len
    {loop_offset, loop_len}
  end

  defp calc_cycles_left(n, {offset, len}), do: rem(n - (offset - 1), len) - 1

  # --- Parser and Utils

  defp parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.graphemes/1)
  end

  defp flip(grid) do
    grid
    |> Enum.zip()
    |> Enum.map(&Tuple.to_list/1)
  end

  defp flip_and_reverse(grid) do
    grid
    |> Enum.zip()
    |> Enum.map(&(&1 |> Tuple.to_list() |> Enum.reverse()))
  end

  defp reverse(grid), do: Enum.map(grid, &Enum.reverse/1)

  defp reverse_and_flip(grid), do: grid |> reverse() |> flip()

  defp grid_hash(grid), do: grid |> :erlang.md5() |> Base.encode16(case: :lower)
end
