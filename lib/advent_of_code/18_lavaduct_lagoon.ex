defmodule AdventOfCode.LavaductLagoon do
  @moduledoc """
  # Day 18: Lavaduct Lagoon

  ## Part One

  Thanks to your efforts, the machine parts factory is one of the first factories up
  and running since the lavafall came back. However, to catch up with the large backlog
  of parts requests, the factory will also need a large supply of lava for a while;
  the Elves have already started creating a large lagoon nearby for this purpose.

  However, they aren't sure the lagoon will be big enough; they've asked you to take
  a look at the dig plan (your puzzle input). For example:

      R 6 (#70c710)
      D 5 (#0dc571)
      L 2 (#5713f0)
      D 2 (#d2c081)
      R 2 (#59c680)
      D 2 (#411b91)
      L 5 (#8ceee2)
      U 2 (#caa173)
      L 1 (#1b58a2)
      U 2 (#caa171)
      R 2 (#7807d2)
      U 3 (#a77fa3)
      L 2 (#015232)
      U 2 (#7a21e3)

  The digger starts in a 1 meter cube hole in the ground. They then dig the specified
  number of meters up (U), down (D), left (L), or right (R), clearing full 1 meter cubes
  as they go. The directions are given as seen from above, so if "up" were north, then
  "right" would be east, and so on. Each trench is also listed with the color that
  the edge of the trench should be painted as an RGB hexadecimal color code.

  When viewed from above, the above example dig plan would result in the following loop
  of trench (#) having been dug out from otherwise ground-level terrain (.):

      #######
      #.....#
      ###...#
      ..#...#
      ..#...#
      ###.###
      #...#..
      ##..###
      .#....#
      .######

  At this point, the trench could contain 38 cubic meters of lava. However, this is just
  the edge of the lagoon; the next step is to dig out the interior so that it is one
  meter deep as well:

      #######
      #######
      #######
      ..#####
      ..#####
      #######
      #####..
      #######
      .######
      .######

  Now, the lagoon can contain a much more respectable 62 cubic meters of lava. While
  the interior is dug out, the edges are also painted according to the color codes
  in the dig plan.

  The Elves are concerned the lagoon won't be large enough; if they follow their
  dig plan, **how many cubic meters of lava could it hold?**


  ## Part Two

  The Elves were right to be concerned; the planned lagoon would be much too small.

  After a few minutes, someone realizes what happened; someone swapped the color and
  instruction parameters when producing the dig plan. They don't have time to fix
  the bug; one of them asks if you can extract the correct instructions from the
  hexadecimal codes.

  Each hexadecimal code is six hexadecimal digits long. The first five hexadecimal
  digits encode the distance in meters as a five-digit hexadecimal number. The last
  hexadecimal digit encodes the direction to dig: 0 means R, 1 means D, 2 means L,
  and 3 means U.

  So, in the above example, the hexadecimal codes can be converted into the true
  instructions:

      #70c710 = R 461937
      #0dc571 = D 56407
      #5713f0 = R 356671
      #d2c081 = D 863240
      #59c680 = R 367720
      #411b91 = D 266681
      #8ceee2 = L 577262
      #caa173 = U 829975
      #1b58a2 = L 112010
      #caa171 = D 829975
      #7807d2 = L 491645
      #a77fa3 = U 686074
      #015232 = L 5411
      #7a21e3 = U 500254

  Digging out this loop and its interior produces a lagoon that can hold an impressive
  952408144115 cubic meters of lava.

  Convert the hexadecimal color codes into the correct instructions; if the Elves follow
  this new dig plan, **how many cubic meters of lava could the lagoon hold?**
  """

  @doc "How many cubic meters of could be hold by dug out lagoon"
  def answer(input) do
    input |> parse() |> process_map() |> calculate()
  end

  @doc "How many cubic meters of could be hold by dug out lagoon with corrected input"
  def final_answer(input) do
    input |> correct_input() |> process_map() |> calculate()
  end

  # The solution is Shoelace formula + Pick's theorem:
  defp calculate({map, perim}), do: calc_interior(map) + div(perim, 2) + 1

  defp calc_interior(list) do
    {xf, yf} = hd(list)

    {a, b} =
      list
      |> Enum.chunk_every(2, 1)
      |> Enum.reduce({0, 0}, fn
        [{x1, y1}, {x2, y2}], {a, b} -> {a + x1 * y2, b + y1 * x2}
        [{xl, yl}], {a, b} -> {a + xf * yl, b + yf * xl}
      end)

    div(abs(a - b), 2)
  end

  # --- Building map ---

  defp process_map(list, cur \\ {0, 0}, area \\ 0, acc \\ [])

  defp process_map([], _cur, area, acc), do: {acc, area}

  defp process_map([{dir, n} | rest], {x, y}, area, acc) do
    {nx, ny} =
      case dir do
        "L" -> {x - n, y}
        "R" -> {x + n, y}
        "D" -> {x, y + n}
        "U" -> {x, y - n}
      end

    process_map(rest, {nx, ny}, area + n, [{x, y} | acc])
  end

  # --- Parser ---

  defp parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_line/1)
  end

  defp parse_line(line) do
    [d, n, _] = Regex.run(~r/(\w) (\d+) \(#(.{6})\)/, line, capture: :all_but_first)
    {d, String.to_integer(n)}
  end

  defp correct_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&correct_line/1)
  end

  defp correct_line(line) do
    [hex, dir] = Regex.run(~r/\(#(\w{5})([0-3])\)/, line, capture: :all_but_first)
    {n, ""} = Integer.parse(hex, 16)
    d = %{"0" => "R", "1" => "D", "2" => "L", "3" => "U"}[dir]
    {d, n}
  end
end
