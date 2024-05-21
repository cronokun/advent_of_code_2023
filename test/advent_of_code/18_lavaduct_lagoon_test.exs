defmodule AdventOfCode.LavaductLagoonTest do
  use ExUnit.Case

  import AdventOfCode.LavaductLagoon

  test ".answer/1 returns how many cubic meters of could be hold by dug out lagoon" do
    # #-----#
    # |.....|
    # #-#...|
    # ..|...|
    # ..|...|
    # #-#.#-#
    # |...|..
    # ##..#-#
    # .|....|
    # .#----#

    assert 62 ==
             answer(~S"""
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
             """)
  end

  test ".final_answer/1 correctly parses input and returns lagoon volume" do
    assert 952_408_144_115 ==
             final_answer(~S"""
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
             """)
  end
end
