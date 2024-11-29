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

  ## Part Two

  Upon further analysis, it doesn't seem like any hailstones will naturally collide. It's up to
  you to fix that!

  You find a rock on the ground nearby. While it seems extremely unlikely, if you throw it just
  right, you should be able to hit every hailstone in a single throw!

  You can use the probably-magical winds to reach any integer position you like and to propel the
  rock at any integer velocity. Now including the Z axis in your calculations, if you throw the
  rock at time 0, where do you need to be so that the rock perfectly collides with every
  hailstone? Due to probably-magical inertia, the rock won't slow down or change direction when
  it collides with a hailstone.

  In the example above, you can achieve this by moving to position 24, 13, 10 and throwing the
  rock at velocity -3, 1, 2. If you do this, you will hit every hailstone as follows:

  - Hailstone: 19, 13, 30 @ -2, 1, -2
    Collision time: 5
    Collision position: 9, 18, 20

  - Hailstone: 18, 19, 22 @ -1, -1, -2
    Collision time: 3
    Collision position: 15, 16, 16

  - Hailstone: 20, 25, 34 @ -2, -2, -4
    Collision time: 4
    Collision position: 12, 17, 18

  - Hailstone: 12, 31, 28 @ -1, -2, -1
    Collision time: 6
    Collision position: 6, 19, 22

  - Hailstone: 20, 19, 15 @ 1, -5, -3
    Collision time: 1
    Collision position: 21, 14, 12

  Above, each hailstone is identified by its initial position and its velocity. Then, the time
  and position of that hailstone's collision with your rock are given.

  After 1 nanosecond, the rock has exactly the same position as one of the hailstones,
  obliterating it into ice dust! Another hailstone is smashed to bits two nanoseconds after that.
  After a total of 6 nanoseconds, all of the hailstones have been destroyed.

  So, at time 0, the rock needs to be at X position 24, Y position 13, and Z position 10. Adding
  these three coordinates together produces 47. (Don't add any coordinates from the rock's
  velocity.)

  Determine the exact position and velocity the rock needs to have at time 0 so that it perfectly
  collides with every hailstone. What do you get if you add up the X, Y, and Z coordinates of
  that initial position?
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

  # ---- Part 2 --------

  @doc "Returns sum of coordinates of initial stone position."
  def final_answer(input) do
    [h0 | _] = hs = parse(input)
    [_, h1, h2, h3] = center_on_hailstone(hs, h0)
    n = find_plane(h1)
    i2 = line_plane_intersection(h2, n)
    i3 = line_plane_intersection(h3, n)

    relative_rock_position(i2, i3)
    |> absolute_rock_position(h0)
    |> Enum.sum()
  end

  defp center_on_hailstone(hs, [x0, y0, z0, vx0, vy0, vz0]) do
    hs
    |> Enum.take(4)
    |> Enum.map(fn [x, y, z, vx, vy, vz] ->
      [x - x0, y - y0, z - z0, vx - vx0, vy - vy0, vz - vz0]
    end)
  end

  defp find_plane([x, y, z, vx, vy, vz]) do
    [x1, y1, z1] = [x + vx, y + vy, z + vz]
    [y * z1 - z * y1, z * x1 - x * z1, x * y1 - y * x1]
  end

  defp line_plane_intersection([x, y, z, vx, vy, vz], [nx, ny, nz]) do
    a = -x * nx - y * ny - z * nz
    b = vx * nx + vy * ny + vz * nz
    t = div(a, b)
    p = [x + vx * t, y + vy * t, z + vz * t]
    {p, t}
  end

  defp relative_rock_position({[x2, y2, z2], t2}, {[x3, y3, z3], t3}) do
    dt = t2 - t3
    # Rock direction:
    [dx, dy, dz] = [div(x2 - x3, dt), div(y2 - y3, dt), div(z2 - z3, dt)]
    # Rock position:
    [x2 - dx * t2, y2 - dy * t2, z2 - dz * t2]
  end

  defp absolute_rock_position([x, y, z], [x0, y0, z0, _, _, _]), do: [x0 + x, y0 + y, z0 + z]

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
