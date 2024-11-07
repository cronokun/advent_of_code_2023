defmodule AdventOfCode.LensLibraryTest do
  use ExUnit.Case, async: true

  import AdventOfCode.LensLibrary

  test ".answer/1 returns sum of all initialization sequence hashes" do
    input = "rn=1,cm-,qp=3,cm=2,qp-,pc=4,ot=9,ab=5,pc-,pc=6,ot=7"
    assert answer(input) == 1_320
  end

  test ".final_answer/1 returns sum of all lenses focusing power" do
    input = "rn=1,cm-,qp=3,cm=2,qp-,pc=4,ot=9,ab=5,pc-,pc=6,ot=7"
    assert final_answer(input) == 145
  end

  @test_input File.read!("priv/15_initialization_sequence")

  test "Day 15, part 1" do
    assert answer(@test_input) == 513_214
  end

  test "Day 15, part 2" do
    assert final_answer(@test_input) == 258_826
  end
end
