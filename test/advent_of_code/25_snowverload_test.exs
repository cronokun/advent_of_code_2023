defmodule AdventOfCode.SnowverloadTest do
  use ExUnit.Case, async: true

  import AdventOfCode.Snowverload

  test ".answer/1 splits graph in two and multiplies sizes of two groups" do
    assert answer(~S"""
           jqt: rhn xhk nvd
           rsh: frs pzl lsr
           xhk: hfx
           cmg: qnr nvd lhk bvb
           rhn: xhk bvb hfx
           bvb: xhk hfx
           pzl: lsr hfx nvd
           qnr: nvd
           ntq: jqt hfx bvb xhk
           nvd: lhk
           lsr: lhk
           rzs: qnr cmg lsr rsh
           frs: qnr lhk lsr
           """) == 54
  end

  test "Day 25, part 1" do
    assert File.read!("priv/25_wiring_diagram") |> answer() == 568_214
  end
end
