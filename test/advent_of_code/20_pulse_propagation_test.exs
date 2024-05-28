defmodule AdventOfCode.PulsePropagationTest do
  use ExUnit.Case

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
end
