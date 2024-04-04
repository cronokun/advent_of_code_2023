defmodule AdventOfCodeTest do
  use ExUnit.Case

  test "Day 1, part 1: Trebuchet Calibration Number" do
    assert AdventOfCode.trebuchet_calibration_number() == 54_877
  end

  test "Day 1, part 2: Advenced Trebuchet Calibration Number" do
    assert AdventOfCode.advanced_trebuchet_calibration_number() == 54_100
  end

  test "Day 2, part 1: Cube Conundrum" do
    assert AdventOfCode.cube_conundrum() == 2_061
  end

  test "Day 2, part 2: Cude Conundrum continues" do
    assert AdventOfCode.cube_conundrum_continues() == 72_596
  end

  test "Day 3, part 1: Gear Ratios" do
    assert AdventOfCode.gear_ratios() == 546_312
  end

  test "Day 3, part 2: Gear Ratios" do
    assert AdventOfCode.final_gear_ratios() == 87_449_461
  end

  test "Day 4, part 1: Scratchcards" do
    assert AdventOfCode.scratchcards() == 21_568
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

  test "Day 6, part 2: Really wait for it" do
    assert AdventOfCode.really_wait_for_it() == 27_102_791
  end

  test "Day 7, part 1: Camel cards" do
    assert AdventOfCode.camel_cards() == 251_806_792
  end

  test "Day 7, part 2: Camel cards with joker" do
    assert AdventOfCode.camel_cards_with_joker() == 252_113_488
  end

  test "Day 8, part 1: Haunted wasteland" do
    assert AdventOfCode.haunted_wastland() == 21_883
  end

  test "Day 8, part 2: Haunted wasteland" do
    assert AdventOfCode.final_haunted_wastland() == 12_833_235_391_111
  end

  test "Day 9, part 1: Mirage maintenance" do
    assert AdventOfCode.mirage_maintenance() == 1_934_898_178
  end

  test "Day 9, part 2: Mirage maintenance" do
    assert AdventOfCode.final_mirage_maintenance() == 1_129
  end

  test "Day 10, part 1: Pipe maze" do
    assert AdventOfCode.pipe_maze() == 6_927
  end

  test "Day 10, part 2: Pipe maze" do
    assert AdventOfCode.final_pipe_maze() == 467
  end

  test "Day 11, part 1: Cosmic expansion" do
    assert AdventOfCode.cosmic_expansion() == 9_918_828
  end

  test "Day 11, part 2: Greater cosmic expansion" do
    assert AdventOfCode.greater_cosmic_expansion() == 692_506_533_832
  end

  test "Day 12, part 1: Hot springs" do
    assert AdventOfCode.hot_springs() == 7_007
  end

  test "Day 12, part 2: Unfolded hot springs" do
    assert AdventOfCode.unfolded_hot_springs() == 3_476_169_006_222
  end

  test "Day 13, part 1: Point of incidence" do
    assert AdventOfCode.point_of_incidence() == 35_521
  end

  test "Day 13, part 2: Point of incidence with fixed smudge" do
    assert AdventOfCode.fixed_point_of_incidence() == 34_795
  end

  test "Day 14, part 1: Parabolic reflector dish" do
    assert AdventOfCode.parabolic_reflector_dish() == 107_430
  end

  test "Day 14, part 2: Spinned parabolic reflector dish" do
    assert AdventOfCode.spinned_parabolic_reflector_dish() == 96_317
  end

  test "Day 15, part 1: Lens library" do
    assert AdventOfCode.lens_library() == 513_214
  end

  test "Day 15, part 2: Lens library focusing power" do
    assert AdventOfCode.final_lens_library() == 258_826
  end

  test "Day 16, part 1: Floor will be lava" do
    assert AdventOfCode.floor_will_be_lava() == 6_622
  end

  test "Day 16, part 2: Floor really will be lava" do
    assert AdventOfCode.floor_really_will_be_lava() == 7_130
  end

  test "Day 17, part 1: Clumsy crucible" do
    assert AdventOfCode.clumsy_crucible() == 936
  end

  test "Day 17, part 2: Ultra clumsy crucible" do
    assert AdventOfCode.ultra_clumsy_crucible() == 1_157
  end
end
