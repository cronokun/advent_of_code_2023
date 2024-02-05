defmodule AdventOfCode.LensLibraryTest do
  use ExUnit.Case

  import AdventOfCode.LensLibrary

  test ".answer/1 Returns sum of all initialization sequence hashes" do
    input = "rn=1,cm-,qp=3,cm=2,qp-,pc=4,ot=9,ab=5,pc-,pc=6,ot=7"
    assert answer(input) == 1_320
  end
end
