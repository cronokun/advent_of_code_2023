defmodule AdventOfCodeTest do
  use ExUnit.Case

  test "Day 1, part 1: Trebuchet Calibration Number" do
    assert AdventOfCode.trebuchet_calibration_number() == 54877
  end

  test "Day 1, part 2: Advenced Trebuchet Calibration Number" do
    assert AdventOfCode.advanced_trebuchet_calibration_number() == 54100
  end

  test "Day 2, part 1: Cube Conundrum" do
    assert AdventOfCode.cube_conundrum() == 2061
  end

  test "Day 2, part 2: Cude Conundrum continues" do
    assert AdventOfCode.cube_conundrum_continues() == 72596
  end

  test "Day 3, part 1: Gear Ratios" do
    assert AdventOfCode.gear_ratios() == 546_312
  end

  test "Day 3, part 2: Gear Ratios" do
    assert AdventOfCode.final_gear_ratios() == 87_449_461
  end
end
