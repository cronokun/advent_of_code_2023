defmodule AdventOfCode.Aplenty do
  @moduledoc """
  # Day 19: Aplenty

  ## Part One

  The Elves of Gear Island are thankful for your help and send you on your way. They
  even have a hang glider that someone stole from Desert Island; since you're already
  going that direction, it would help them a lot if you would use it to get down there
  and return it to them.

  As you reach the bottom of the relentless avalanche of machine parts, you discover
  that they're already forming a formidable heap. Don't worry, though - a group of
  Elves is already here organizing the parts, and they have a system.

  To start, each part is rated in each of four categories:

  - x: Extremely cool looking
  - m: Musical (it makes a noise when you hit it)
  - a: Aerodynamic
  - s: Shiny

  Then, each part is sent through a series of workflows that will ultimately accept or
  reject the part. Each workflow has a name and contains a list of rules; each rule
  specifies a condition and where to send the part if the condition is true. The first
  rule that matches the part being considered is applied immediately, and the part moves
  on to the destination described by the rule. (The last rule in each workflow has no
  condition and always applies if reached.)

  Consider the workflow ex{x>10:one,m<20:two,a>30:R,A}. This workflow is named ex and
  contains four rules. If workflow ex were considering a specific part, it would perform
  the following steps in order:

  - Rule "x>10:one": If the part's x is more than 10, send the part to the workflow
    named one.
  - Rule "m<20:two": Otherwise, if the part's m is less than 20, send the part to
    the workflow named two.
  - Rule "a>30:R": Otherwise, if the part's a is more than 30, the part is immediately
    rejected (R).
  - Rule "A": Otherwise, because no other rules matched the part, the part is immediately
    accepted (A).
  - If a part is sent to another workflow, it immediately switches to the start of that
    workflow instead and never returns. If a part is accepted (sent to A) or rejected
    (sent to R), the part immediately stops any further processing.

  The system works, but it's not keeping up with the torrent of weird metal shapes. The
  Elves ask if you can help sort a few parts and give you the list of workflows and some
  part ratings (your puzzle input). For example:

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

  The workflows are listed first, followed by a blank line, then the ratings of the
  parts the Elves would like you to sort. All parts begin in the workflow named in.
  In this example, the five listed parts go through the following workflows:

  - {x=787,m=2655,a=1222,s=2876}: in -> qqz -> qs -> lnx -> A
  - {x=1679,m=44,a=2067,s=496}: in -> px -> rfg -> gd -> R
  - {x=2036,m=264,a=79,s=2244}: in -> qqz -> hdj -> pv -> A
  - {x=2461,m=1339,a=466,s=291}: in -> px -> qkq -> crn -> R
  - {x=2127,m=1623,a=2188,s=1013}: in -> px -> rfg -> A

  Ultimately, three parts are accepted. Adding up the x, m, a, and s rating for each
  of the accepted parts gives 7540 for the part with x=787, 4623 for the part with
  x=2036, and 6951 for the part with x=2127. Adding all of the ratings for all of the
  accepted parts gives the sum total of 19114.

  Sort through all of the parts you've been given; **what do you get if you add together
  all of the rating numbers for all of the parts that ultimately get accepted?**


  ## Part Two

  Even with your help, the sorting process still isn't fast enough.

  One of the Elves comes up with a new plan: rather than sort parts individually through
  all of these workflows, maybe you can figure out in advance which combinations of
  ratings will be accepted or rejected.

  Each of the four ratings (x, m, a, s) can have an integer value ranging from a minimum
  of 1 to a maximum of 4000. Of all possible distinct combinations of ratings, your job
  is to figure out which ones will be accepted.

  In the above example, there are 167409079868000 distinct combinations of ratings that
  will be accepted.

  Consider only your list of workflows; the list of part ratings that the Elves wanted
  you to sort is no longer relevant. **How many distinct combinations of ratings will be
  accepted by the Elves' workflows?**
  """

  @doc "Sum of rating numbers of all accepted parts"
  def answer(input) do
    parse(input)
    |> filter_parts()
    |> calc_sum()
  end

  defp filter_parts({parts, workflows}) do
    Enum.filter(parts, fn part -> run_workflow(part, "in", workflows) end)
  end

  defp calc_sum(parts) do
    parts
    |> Enum.flat_map(&Map.values(&1))
    |> Enum.sum()
  end

  defp run_workflow(_part, "A", _workflows), do: true
  defp run_workflow(_part, "R", _workflows), do: false

  defp run_workflow(part, wname, workflows),
    do: run_instruction(part, workflows[wname], workflows)

  defp run_instruction(part, [{true, _, _, next}], workflows),
    do: run_workflow(part, next, workflows)

  defp run_instruction(part, [{op, attr, val, next} | rest], workflows) do
    matched =
      case op do
        :gt -> part[attr] > val
        :lt -> part[attr] < val
      end

    if matched do
      run_workflow(part, next, workflows)
    else
      run_instruction(part, rest, workflows)
    end
  end

  # --- Part Two ---

  @doc "Returns number of combinations of all accepted parts"
  def final_answer(input, range \\ 1..4000) do
    {_, workflows} = parse(input)

    %{"x" => range, "m" => range, "a" => range, "s" => range}
    |> process(workflows, "in", [], [])
    |> calc_combinations()
  end

  defp calc_combinations(parts) do
    parts |> Enum.map(&part_comb/1) |> Enum.sum()
  end

  defp part_comb(part) do
    part |> Map.values() |> Enum.reduce(1, fn rng, acc -> acc * Enum.count(rng) end)
  end

  defp process(_, _workflows, nil, [], acc), do: acc

  defp process(parts, workflows, wname, todo, acc) do
    {accepted, next} = process_workflow(parts, workflows[wname], [], [])
    {nextp, nextw, todo} = get_next_workflow(todo ++ next)
    process(nextp, workflows, nextw, todo, acc ++ accepted)
  end

  defp get_next_workflow([]), do: {nil, nil, []}
  defp get_next_workflow([{nextw, nextp} | todo]), do: {nextp, nextw, todo}

  defp process_workflow(parts, [{true, nil, nil, next_op}], next, acc) do
    case next_op do
      "A" -> {[parts | acc], next}
      "R" -> {acc, next}
      _ -> {acc, [{next_op, parts} | next]}
    end
  end

  defp process_workflow(parts, [rule | rest], next, acc) do
    case apply_rule(parts, rule) do
      [{"A", p1}, {_, p2}] -> process_workflow(p2, rest, next, [p1 | acc])
      [{"R", _p1}, {_, p2}] -> process_workflow(p2, rest, next, acc)
      [next_rule, {_, p2}] -> process_workflow(p2, rest, [next_rule | next], acc)
    end
  end

  defp apply_rule(parts, {op, attr, val, next}) do
    {matched, unmatched} = split_range(parts[attr], val, op)

    [
      {next, Map.put(parts, attr, matched)},
      {nil, Map.put(parts, attr, unmatched)}
    ]
  end

  defp split_range(a..b, val, :gt) when val > a and val < b, do: {(val + 1)..b, a..val}
  defp split_range(a..b, val, :lt) when val > a and val < b, do: {a..(val - 1), val..b}

  # ---  Parser ---

  defp parse(input) do
    [a, b] = String.split(input, "\n\n", trim: true)
    {parse_parts(b), parse_workflows(a)}
  end

  @part_regex ~r/{x=(\d+),m=(\d+),a=(\d+),s=(\d+)/

  defp parse_parts(input) do
    input
    |> String.split()
    |> Enum.map(fn part ->
      [x, m, a, s] =
        Regex.run(@part_regex, part, capture: :all_but_first)
        |> Enum.map(&String.to_integer/1)

      %{"x" => x, "m" => m, "a" => a, "s" => s}
    end)
  end

  defp parse_workflows(input) do
    input |> String.split() |> Enum.map(&parse_workflow_input/1) |> Map.new()
  end

  defp parse_workflow_input(input) do
    [name, instructions] = Regex.run(~r/(\w+){(.+)}/, input, capture: :all_but_first)
    {name, parse_workflow_instructions(instructions)}
  end

  defp parse_workflow_instructions(input) do
    input
    |> String.split(",")
    |> Enum.map(fn str ->
      case Regex.run(~r/(\w)([<>])(\d+):(\w+)/, str, capture: :all_but_first) do
        [attr, op, val, instr] ->
          op = %{">" => :gt, "<" => :lt}[op]
          val = String.to_integer(val)
          {op, attr, val, instr}

        nil ->
          {true, nil, nil, str}
      end
    end)
  end
end
