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

  test "Day 4, part 1: Scratchcards" do
    assert AdventOfCode.scratchcards() == 21568
  end

  test "Day 4, part 2: Correct Scratchcards" do
    assert AdventOfCode.final_scratchcards() == 11_827_296
  end

  test "Day 5, part 1: Food production problem" do
    assert AdventOfCode.food_production_problem() == 484_023_871
  end

  test "Day 5, part 2: Final food production problem" do
    assert AdventOfCode.final_food_production_problem() == 46_294_175
  end

  test "Day 6, part 1: Wait for it" do
    assert AdventOfCode.wait_for_it() == 3_316_275
  end
end
