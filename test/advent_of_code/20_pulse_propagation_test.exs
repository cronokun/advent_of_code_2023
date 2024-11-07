defmodule AdventOfCode.PulsePropagationTest do
  use ExUnit.Case, async: true

  import AdventOfCode.PulsePropagation

  test ".answer/1 returns product of total numbers of low and hight pulses sent" do
    assert 32_000_000 ==
             answer(~S"""
             broadcaster -> a, b, c
             %a -> b
             %b -> c
             %c -> inv
             &inv -> a
             """)

    assert 11_687_500 ==
             answer(~S"""
             broadcaster -> a
             %a -> inv, con
             &inv -> b
             %b -> con
             &con -> output
             """)
  end

  @test_input File.read!("priv/20_module_config")

  test "Day 20, part 1" do
    assert answer(@test_input) == 886_701_120
  end

  test "Day 20, part 2" do
    assert final_answer(@test_input) == 228_134_431_501_037
  end
end
