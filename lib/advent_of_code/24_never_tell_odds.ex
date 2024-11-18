defmodule AdventOfCode.NeverTellOdds do
  @moduledoc """
  # Day 24: Never Tell Me The Odds

  ## Part One

  It seems like something is going wrong with the snow-making process. Instead of forming snow,
  the water that's been absorbed into the air seems to be forming hail!

  Maybe there's something you can do to break up the hailstones?

  Due to strong, probably-magical winds, the hailstones are all flying through the air in
  perfectly linear trajectories. You make a note of each hailstone's position and velocity (your
  puzzle input). For example:

      19, 13, 30 @ -2,  1, -2
      18, 19, 22 @ -1, -1, -2
      20, 25, 34 @ -2, -2, -4
      12, 31, 28 @ -1, -2, -1
      20, 19, 15 @  1, -5, -3

  Each line of text corresponds to the position and velocity of a single hailstone. The positions
  indicate where the hailstones are right now (at time 0). The velocities are constant and
  indicate exactly how far each hailstone will move in one nanosecond.

  Each line of text uses the format px py pz @ vx vy vz. For instance, the hailstone specified
  by `20, 19, 15 @ 1, -5, -3` has initial X position 20, Y position 19, Z position 15, X velocity 1,
  Y velocity -5, and Z velocity -3. After one nanosecond, the hailstone would be at 21, 14, 12.

  Perhaps you won't have to do anything. How likely are the hailstones to collide with each other
  and smash into tiny ice crystals?

  To estimate this, consider only the X and Y axes; ignore the Z axis. Looking forward in time,
  how many of the hailstones' paths will intersect within a test area? (The hailstones themselves
  don't have to collide, just test for intersections between the paths they will trace.)

  In this example, look for intersections that happen with an X and Y position each at least 7
  and at most 27; in your actual data, you'll need to check a much larger test area. Comparing
  all pairs of hailstones' future paths produces the following results:

  * Hailstone A: 19, 13, 30 @ -2, 1, -2
    Hailstone B: 18, 19, 22 @ -1, -1, -2
    Hailstones' paths will cross inside the test area (at x=14.333, y=15.333).

  * Hailstone A: 19, 13, 30 @ -2, 1, -2
    Hailstone B: 20, 25, 34 @ -2, -2, -4
    Hailstones' paths will cross inside the test area (at x=11.667, y=16.667).

  * Hailstone A: 19, 13, 30 @ -2, 1, -2
    Hailstone B: 12, 31, 28 @ -1, -2, -1
    Hailstones' paths will cross outside the test area (at x=6.2, y=19.4).

  * Hailstone A: 19, 13, 30 @ -2, 1, -2
    Hailstone B: 20, 19, 15 @ 1, -5, -3
    Hailstones' paths crossed in the past for hailstone A.

  * Hailstone A: 18, 19, 22 @ -1, -1, -2
    Hailstone B: 20, 25, 34 @ -2, -2, -4
    Hailstones' paths are parallel; they never intersect.

  * Hailstone A: 18, 19, 22 @ -1, -1, -2
    Hailstone B: 12, 31, 28 @ -1, -2, -1
    Hailstones' paths will cross outside the test area (at x=-6, y=-5).

  * Hailstone A: 18, 19, 22 @ -1, -1, -2
    Hailstone B: 20, 19, 15 @ 1, -5, -3
    Hailstones' paths crossed in the past for both hailstones.

  * Hailstone A: 20, 25, 34 @ -2, -2, -4
    Hailstone B: 12, 31, 28 @ -1, -2, -1
    Hailstones' paths will cross outside the test area (at x=-2, y=3).

  * Hailstone A: 20, 25, 34 @ -2, -2, -4
    Hailstone B: 20, 19, 15 @ 1, -5, -3
    Hailstones' paths crossed in the past for hailstone B.

  * Hailstone A: 12, 31, 28 @ -1, -2, -1
    Hailstone B: 20, 19, 15 @ 1, -5, -3
    Hailstones' paths crossed in the past for both hailstones.

  So, in this example, 2 hailstones' future paths cross inside the boundaries of the test area.

  However, you'll need to search a much larger test area if you want to see if any hailstones
  might collide. Look for intersections that happen with an X and Y position each at least
  200000000000000 and at most 400000000000000. Disregard the Z axis entirely.

  Considering only the X and Y axes, check all pairs of hailstones' future paths for intersections.
  **How many of these intersections occur within the test area?**
  """

  @doc "Number of hailstone intersections that occur withing test area (ignoring Z axis)."
  def answer(input, amin, amax) do
    input
    |> parse()
    |> all_pairs()
    |> Enum.count(&intersect?(&1, amin, amax))
  end

  defp all_pairs(list) do
    for a <- list, b <- list -- [a], uniq: true, do: Enum.sort([a, b])
  end

  def intersect?([a, b], amin, amax) do
    case intersection(a, b) do
      {:ok, p} ->
        in_area?(p, amin, amax) and on_path?(a, p) and on_path?(b, p)

      :error ->
        false
    end
  end

  defp intersection([x1, y1, _, vx1, vy1, _], [x3, y3, _, vx2, vy2, _]) do
    {x2, y2} = {x1 + vx1, y1 + vy1}
    {x4, y4} = {x3 + vx2, y3 + vy2}
    m1 = x1 * y2 - y1 * x2
    m2 = x3 * y4 - y3 * x4
    denom = (x1 - x2) * (y3 - y4) - (y1 - y2) * (x3 - x4)

    if denom == 0 do
      :error
    else
      px = (m1 * (x3 - x4) - (x1 - x2) * m2) / denom
      py = (m1 * (y3 - y4) - (y1 - y2) * m2) / denom
      {:ok, {px, py}}
    end
  end

  defp in_area?({px, py}, amin, amax) do
    px >= amin and px <= amax and py >= amin and py <= amax
  end

  defp on_path?([x, y, _, vx, vy, _], {px, py}) do
    x_match = if vx > 0, do: px > x, else: px < x
    y_match = if vy > 0, do: py > y, else: py < y
    x_match and y_match
  end

  # ---- Parser --------

  defp parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_line/1)
  end

  @parser_regex ~r/(\d+),\s+(\d+),\s+(\d+)\s+@\s+(-?\d+),\s+(-?\d+),\s+(-?\d+)/
  defp parse_line(line) do
    Regex.run(@parser_regex, line, capture: :all_but_first)
    |> Enum.map(&String.to_integer/1)
  end
end
