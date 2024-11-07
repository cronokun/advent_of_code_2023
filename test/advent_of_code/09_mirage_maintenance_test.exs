defmodule AdventOfCode.MirageMaintenanceTest do
  use ExUnit.Case, async: true

  import AdventOfCode.MirageMaintenance

  test ".answer/1 returns sum of next extrapolated history values" do
    input = ~S"""
    0 3 6 9 12 15
    1 3 6 10 15 21
    10 13 16 21 30 45
    """

    assert answer(input) == 114
  end

  test ".final_answer/1 returns sum of previous extrapolated history values" do
    input = ~S"""
    0 3 6 9 12 15
    1 3 6 10 15 21
    10 13 16 21 30 45
    """

    # [-3, 0, 5]
    assert final_answer(input) == 2
  end

  @test_input File.read!("priv/09_report")

  test "Day 9, part 1" do
    assert answer(@test_input) == 1_934_898_178
  end

  test "Day 9, part 2" do
    assert final_answer(@test_input) == 1_129
  end
end
