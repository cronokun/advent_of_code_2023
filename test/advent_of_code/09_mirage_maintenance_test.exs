defmodule AdventOfCode.MirageMaintenanceTest do
  use ExUnit.Case

  import AdventOfCode.MirageMaintenance

  test ".answer/1 returns sum of next extrapolated history values" do
    input = ~S"""
    0 3 6 9 12 15
    1 3 6 10 15 21
    10 13 16 21 30 45
    """

    assert answer(input) == 114
  end

  @tag :focus
  test ".final_answer/1 returns sum of previous extrapolated history values" do
    input = ~S"""
    0 3 6 9 12 15
    1 3 6 10 15 21
    10 13 16 21 30 45
    """

    # [-3, 0, 5]
    assert final_answer(input) == 2
  end
end
