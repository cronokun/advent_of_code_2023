defmodule AdventOfCode.SandSlabs.Graph do
  @moduledoc """
  This struct represents a bricks graph. It keep track of:

  - which bricks are above and below the given brick;

  - if the given brick is a single prop for other bricks
    (so removing it will make other bricks drop).
  """

  defstruct [:above, :below, :total, :uniq]

  def new do
    %__MODULE__{
      above: %{},
      below: %{},
      total: 0,
      uniq: %{}
    }
  end

  def above(g, brk), do: g.above[brk]
  def below(g, brk), do: g.below[brk]
  def uniq_size(g), do: map_size(g.uniq)

  # ---- Update graph --------

  def put(g, {_, _, brick}, props) do
    labels = Enum.map(props, &elem(&1, 2))

    g
    |> put_empty_above(brick)
    |> put_above(brick, labels)
    |> put_below(brick, labels)
    |> put_uniq(brick, labels)
    |> update_total()
  end

  defp put_empty_above(g, brk), do: put_in(g.above[brk], [])

  defp put_above(g, brk, labels) do
    Enum.reduce(labels, g, fn lbl, gg ->
      update_in(gg.above, fn m -> Map.update(m, lbl, [brk], &[brk | &1]) end)
    end)
  end

  defp put_below(g, brk, labels) do
    update_in(g.below, fn m -> Map.update(m, brk, labels, &(labels ++ &1)) end)
  end

  defp put_uniq(g, brick, [label]) do
    update_in(g.uniq, fn map -> Map.update(map, label, [brick], &[brick | &1]) end)
  end

  defp put_uniq(g, _brick, _labels), do: g

  defp update_total(g), do: update_in(g.total, &(&1 + 1))
end

defmodule AdventOfCode.SandSlabs do
  @moduledoc """
  # Day 22: Sand Slabs

  ## Part One

  Enough sand has fallen; it can finally filter water for Snow Island.

  Well, almost.

  The sand has been falling as large compacted bricks of sand, piling up to form an impressive
  stack here near the edge of Island Island. In order to make use of the sand to filter water,
  some of the bricks will need to be broken apart - nay, disintegrated - back into freely flowing
  sand.

  The stack is tall enough that you'll have to be careful about choosing which bricks to
  disintegrate; if you disintegrate the wrong brick, large portions of the stack could topple,
  which sounds pretty dangerous.

  The Elves responsible for water filtering operations took a **snapshot of the bricks while they
  were still falling** (your puzzle input) which should let you work out which bricks are safe to
  disintegrate. For example:

    1,0,1~1,2,1
    0,0,2~2,0,2
    0,2,3~2,2,3
    0,0,4~0,2,4
    2,0,5~2,2,5
    0,1,6~2,1,6
    1,1,8~1,1,9

  Each line of text in the snapshot represents the position of a single brick at the time the
  snapshot was taken. The position is given as two `x,y,z` coordinates - one for each end of the
  brick - separated by a tilde (`~`). Each brick is made up of a single straight line of cubes,
  and the Elves were even careful to choose a time for the snapshot that had all of the free-
  falling bricks at integer positions above the ground, so the whole snapshot is aligned to a
  three-dimensional cube grid.

  A line like `2,2,2~2,2,2` means that both ends of the brick are at the same coordinate - in
  other words, that the brick is a single cube.

  Lines like `0,0,10~1,0,10` or `0,0,10~0,1,10` both represent bricks that are two cubes in
  volume, both oriented horizontally. The first brick extends in the `x` direction, while the
  second brick extends in the `y` direction.

  A line like `0,0,1~0,0,10` represents a ten-cube brick which is oriented vertically. One end of
  the brick is the cube located at `0,0,1`, while the other end of the brick is located directly
  above it at `0,0,10`.

  The ground is at `z=0` and is perfectly flat; the lowest `z` value a brick can have is
  therefore `1`. So, `5,5,1~5,6,1` and `0,2,1~0,2,5` are both resting on the ground, but
  `3,3,2~3,3,3` was above the ground at the time of the snapshot.

  Because the snapshot was taken while the bricks were still falling, some bricks will **still be
  in the air**; you'll need to start by figuring out where they will end up. Bricks are magically
  stabilized, so they **never rotate**, even in weird situations like where a long horizontal
  brick is only supported on one end. Two bricks cannot occupy the same position, so a falling
  brick will come to rest upon the first other brick it encounters.

  Here is the same example again, this time with each brick given a letter so it can be marked in
  diagrams:

    1,0,1~1,2,1   <- A
    0,0,2~2,0,2   <- B
    0,2,3~2,2,3   <- C
    0,0,4~0,2,4   <- D
    2,0,5~2,2,5   <- E
    0,1,6~2,1,6   <- F
    1,1,8~1,1,9   <- G

  At the time of the snapshot, from the side so the x axis goes left to right, these bricks are
  arranged like this:

     x
    012
    .G. 9
    .G. 8
    ... 7
    FFF 6
    ..E 5 z
    D.. 4
    CCC 3
    BBB 2
    .A. 1
    --- 0

  Rotating the perspective 90 degrees so the `y` axis now goes left to right, the same bricks are
  arranged like this:

     y
    012
    .G. 9
    .G. 8
    ... 7
    .F. 6
    EEE 5 z
    DDD 4
    ..C 3
    B.. 2
    AAA 1
    --- 0

  Once all of the bricks fall downward as far as they can go, the stack looks like this, where `?`
  means bricks are hidden behind other bricks at that location:

     x
    012
    .G. 6
    .G. 5
    FFF 4
    D.E 3 z
    ??? 2
    .A. 1
    --- 0

  Again from the side:

     y
    012
    .G. 6
    .G. 5
    .F. 4
    ??? 3 z
    B.C 2
    AAA 1
    --- 0

  Now that all of the bricks have settled, it becomes easier to tell which bricks are supporting
  which other bricks:

  - Brick A is the only brick supporting bricks B and C.
  - Brick B is one of two bricks supporting brick D and brick E.
  - Brick C is the other brick supporting brick D and brick E.
  - Brick D supports brick F.
  - Brick E also supports brick F.
  - Brick F supports brick G.
  - Brick G isn't supporting any bricks.

  Your first task is to figure out **which bricks are safe to disintegrate**. A brick can be
  safely disintegrated if, after removing it, **no other bricks** would fall further directly
  downward. Don't actually disintegrate any bricks - just determine what would happen if, for
  each brick, only that brick were disintegrated. Bricks can be disintegrated even if they're
  completely surrounded by other bricks; you can squeeze between bricks if you need to.

  In this example, the bricks can be disintegrated as follows:

  - Brick A cannot be disintegrated safely; if it were disintegrated, bricks B and C would both fall.
  - Brick B can be disintegrated; the bricks above it (D and E) would still be supported by brick C.
  - Brick C can be disintegrated; the bricks above it (D and E) would still be supported by brick B.
  - Brick D can be disintegrated; the brick above it (F) would still be supported by brick E.
  - Brick E can be disintegrated; the brick above it (F) would still be supported by brick D.
  - Brick F cannot be disintegrated; the brick above it (G) would fall.
  - Brick G can be disintegrated; it does not support any other bricks.

  So, in this example, 5 bricks can be safely disintegrated.

  Figure how the blocks will settle based on the snapshot. Once they've settled, consider
  disintegrating a single brick; **how many bricks could be safely chosen as the one to get
  disintegrated?**

  --- Part Two ---

  Disintegrating bricks one at a time isn't going to be fast enough. While it might sound
  dangerous, what you really need is a chain reaction.

  You'll need to figure out the best brick to disintegrate. For each brick, determine how many
  other bricks would fall if that brick were disintegrated.

  Using the same example as above:

  - Disintegrating brick A would cause all 6 other bricks to fall.
  - Disintegrating brick F would cause only 1 other brick, G, to fall.

  Disintegrating any other brick would cause no other bricks to fall. So, in this example, the
  sum of the number of other bricks that would fall as a result of disintegrating each brick is 7.

  For each brick, determine how many other bricks would fall if that brick were disintegrated.
  **What is the sum of the number of other bricks that would fall?**
  """

  alias AdventOfCode.SandSlabs.Graph

  @doc "How many bricks could be safely chosen as the one to get disintegrated?"
  def answer(input) do
    graph =
      input
      |> parse()
      |> apply_gravity()

    graph.total - Graph.uniq_size(graph)
  end

  @doc "Sum of the number of other bricks that would fall?"
  def final_answer(input) do
    input
    |> parse()
    |> apply_gravity()
    |> calc_drops()
  end

  # ---- Gravity --------

  defp apply_gravity(bricks, grid \\ [], acc \\ Graph.new())
  defp apply_gravity([], _grid, acc), do: acc

  defp apply_gravity([brick | rest], grid, acc) do
    {new_brick, new_acc} =
      case put_down_brick(brick, grid) do
        :none ->
          {
            update_brick(brick, 0),
            Graph.put(acc, brick, [])
          }

        {:single, z, prop} ->
          {
            update_brick(brick, z + 1),
            Graph.put(acc, brick, [prop])
          }

        {:multi, z, props} ->
          {
            update_brick(brick, z + 1),
            Graph.put(acc, brick, props)
          }
      end

    apply_gravity(rest, [new_brick | grid], new_acc)
  end

  defp put_down_brick(brick, grid) do
    grid
    |> Enum.reduce({0, []}, fn
      {_, {_, _, z}, _} = brk, {lvl, acc} when z >= lvl ->
        case {bricks_overlap?(brk, brick), z > lvl} do
          {true, true} -> {z, [brk]}
          {true, false} -> {lvl, [brk | acc]}
          {false, _} -> {lvl, acc}
        end

      _, {lvl, acc} ->
        {lvl, acc}
    end)
    |> case do
      {0, []} -> :none
      {z, [prop]} -> {:single, z, prop}
      {z, props} -> {:multi, z, props}
    end
  end

  defp bricks_overlap?({{ax1, ay1, _}, {ax2, ay2, _}, _}, {{bx1, by1, _}, {bx2, by2, _}, _}) do
    !Range.disjoint?(bx1..bx2, ax1..ax2) and !Range.disjoint?(by1..by2, ay1..ay2)
  end

  defp update_brick({{x1, y1, z1}, {x2, y2, z2}, label}, zz),
    do: {{x1, y1, zz}, {x2, y2, zz + (z2 - z1)}, label}

  # ---- Calculate drops --------

  defp calc_drops(g) do
    Enum.reduce(g.uniq, 0, fn {_brk, above}, total ->
      droped = do_calc_drops(g, above, MapSet.new())
      total + MapSet.size(droped)
    end)
  end

  defp do_calc_drops(_g, [], droped), do: droped

  defp do_calc_drops(g, bricks, droped) do
    droped = MapSet.union(droped, MapSet.new(bricks))

    above =
      bricks
      |> Enum.flat_map(&Graph.above(g, &1))
      |> Enum.filter(&all_props_droped?(g, &1, droped))
      |> Enum.uniq()

    do_calc_drops(g, above, droped)
  end

  defp all_props_droped?(g, brk, droped) do
    Enum.all?(Graph.below(g, brk), &MapSet.member?(droped, &1))
  end

  # ---- Parser --------

  defp parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Stream.with_index(1)
    |> Stream.map(fn {line, i} -> parse_line(line, i) end)
    |> Enum.sort_by(fn {{_, _, z1}, {_, _, z2}, _} -> {z1, z2} end)
  end

  @regex ~r/(\d+),(\d+),(\d+)~(\d+),(\d+),(\d+)/

  defp parse_line(line, n) do
    [x1, y1, z1, x2, y2, z2] =
      Regex.run(@regex, line, capture: :all_but_first)
      |> Enum.map(&String.to_integer/1)

    {{x1, y1, z1}, {x2, y2, z2}, n}
  end
end
