defmodule AdventOfCode.MirageMaintenanceTest do
  use ExUnit.Case

  import AdventOfCode.MirageMaintenance

  @tag :focus
  test ".answer/1 returns sum of extrapolated history values" do
    input = ~S"""
    0 3 6 9 12 15
    1 3 6 10 15 21
    10 13 16 21 30 45
    """

    assert answer(input) == 114
  end
end
