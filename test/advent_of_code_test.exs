defmodule AdventOfCodeTest do
  use ExUnit.Case

  test "Day 1, part 1: Trebuchet Calibration Number" do
    assert AdventOfCode.trebuchet_calibration_number() == 54877
  end

  test "Day 1, part 2: Advenced Trebuchet Calibration Number" do
    assert AdventOfCode.advanced_trebuchet_calibration_number() == 54100
  end

  test "Day 1, part 1: Cube Conundrum" do
    assert AdventOfCode.cube_conundrum() == 2061
  end
end
