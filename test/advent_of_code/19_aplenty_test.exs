defmodule AdventOfCode.AplentyTest do
  use ExUnit.Case, async: true

  import AdventOfCode.Aplenty

  test ".answer/1 returns sum of rating numbers of all accepted parts" do
    assert 19_114 ==
             answer(~S"""
             px{a<2006:qkq,m>2090:A,rfg}
             pv{a>1716:R,A}
             lnx{m>1548:A,A}
             rfg{s<537:gd,x>2440:R,A}
             qs{s>3448:A,lnx}
             qkq{x<1416:A,crn}
             crn{x>2662:A,R}
             in{s<1351:px,qqz}
             qqz{s>2770:qs,m<1801:hdj,R}
             gd{a>3333:R,R}
             hdj{m>838:A,pv}

             {x=787,m=2655,a=1222,s=2876}
             {x=1679,m=44,a=2067,s=496}
             {x=2036,m=264,a=79,s=2244}
             {x=2461,m=1339,a=466,s=291}
             {x=2127,m=1623,a=2188,s=1013}
             """)
  end

  test ".final_answer/1 returns number of distinct combinations of ratings accepted by workflows" do
    assert 167_409_079_868_000 ==
             final_answer(~S"""
             px{a<2006:qkq,m>2090:A,rfg}
             pv{a>1716:R,A}
             lnx{m>1548:A,A}
             rfg{s<537:gd,x>2440:R,A}
             qs{s>3448:A,lnx}
             qkq{x<1416:A,crn}
             crn{x>2662:A,R}
             in{s<1351:px,qqz}
             qqz{s>2770:qs,m<1801:hdj,R}
             gd{a>3333:R,R}
             hdj{m>838:A,pv}

             {x=787,m=2655,a=1222,s=2876}
             {x=1679,m=44,a=2067,s=496}
             {x=2036,m=264,a=79,s=2244}
             {x=2461,m=1339,a=466,s=291}
             {x=2127,m=1623,a=2188,s=1013}
             """)
  end

  @test_input File.read!("priv/19_parts_and_workflows")

  test "Day 19, part 1" do
    assert answer(@test_input) == 352_052
  end

  test "Day 19, part 2" do
    assert final_answer(@test_input) == 116_606_738_659_695
  end
end
