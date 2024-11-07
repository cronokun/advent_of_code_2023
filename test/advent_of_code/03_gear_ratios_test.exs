defmodule AdventOfCode.GearRatiosTest do
  use ExUnit.Case, async: true

  import AdventOfCode.GearRatios

  test ".answer/1 returns sum of all of the part numbers" do
    input = ~S"""
    467..114..
    ...*......
    ..35..633.
    ......#...
    617*......
    .....+.58.
    ..592.....
    ......755.
    ...$.*....
    .664.598..
    """

    assert answer(input) == 4361
  end

  test ".answer/1 handles edge indexes correctly" do
    assert answer("1234...5678\n*...........") == 1234
    assert answer("1234...5678\n...........*") == 5678
    assert answer("123..456..789\n*...........%") == 123 + 789
  end

  test ".answer/1 does not duplicate part numbers" do
    input = ~S"""
    123*..
    456#..
    789%..
    """

    assert answer(input) == 123 + 456 + 789

    input = ~S"""
    120*..
    120*..
    120*..
    """

    assert answer(input) == 120 * 3
  end

  test ".final_answer/1 returns sum of all gear ratios" do
    input = ~S"""
    467..114..
    ...*......
    ..35..633.
    ......#...
    617*......
    .....+.58.
    ..592.....
    ......755.
    ...$.*....
    .664.598..
    """

    assert final_answer(input) == 467_835
  end

  @test_input File.read!("priv/03_engine_schematic")

  test "Day 3, part 1" do
    assert answer(@test_input) == 546_312
  end

  test "Day 3, part 2" do
    assert final_answer(@test_input) == 87_449_461
  end
end
