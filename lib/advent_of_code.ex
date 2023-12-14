defmodule AdventOfCode do
  @moduledoc """
  Something is wrong with global snow production, and you've been selected to take a look.
  The Elves have even given you a map; on it, they've used stars to mark the top fifty
  locations that are likely to be having problems.

  You've been doing this long enough to know that to restore snow operations, you
  need to check all fifty stars by December 25th.

  Collect stars by solving puzzles. Two puzzles will be made available on each day
  in the Advent calendar; the second puzzle is unlocked when you complete the first.
  Each puzzle grants one star. Good luck!

  You try to ask why they can't just use a weather machine ("not powerful enough")
  and where they're even sending you ("the sky") and why your map looks mostly blank
  ("you sure ask a lot of questions") and hang on did you just say the sky ("of course,
  where do you think snow comes from") when you realize that the Elves are already
  loading you into a trebuchet ("please hold still, we need to strap you in").
  """

  def trebuchet_calibration_number do
    "priv/01_trebuchet_calibration"
    |> File.read!()
    |> AdventOfCode.Trebuchet.answer()
  end

  def advanced_trebuchet_calibration_number do
    "priv/01_trebuchet_calibration"
    |> File.read!()
    |> AdventOfCode.AdvancedTrebuchet.answer()
  end

  def cube_conundrum do
    "priv/02_cube_game_records"
    |> File.read!()
    |> AdventOfCode.CubeConundrum.answer()
  end

  def cube_conundrum_continues do
    "priv/02_cube_game_records"
    |> File.read!()
    |> AdventOfCode.CubeConundrum.second_answer()
  end

  def gear_ratios do
    "priv/03_engine_schematic"
    |> File.read!()
    |> AdventOfCode.GearRatios.answer()
  end

  def final_gear_ratios do
    "priv/03_engine_schematic"
    |> File.read!()
    |> AdventOfCode.GearRatios.final_answer()
  end

  def scratchcards do
    "priv/04_cards_pile"
    |> File.read!()
    |> AdventOfCode.Scratchcards.answer()
  end

  def final_scratchcards do
    "priv/04_cards_pile"
    |> File.read!()
    |> AdventOfCode.Scratchcards.final_answer()
  end

  def food_production_problem do
    "priv/05_almanach"
    |> File.read!()
    |> AdventOfCode.FoodProductionProblem.answer()
  end

  def final_food_production_problem do
    "priv/05_almanach"
    |> File.read!()
    |> AdventOfCode.BiggerFoodProductionProblem.answer()
  end

  def wait_for_it do
    File.read!("priv/06_race_records")
    |> AdventOfCode.WaitForIt.answer()
  end

  def really_wait_for_it do
    File.read!("priv/06_race_records")
    |> AdventOfCode.WaitForIt.final_answer()
  end

  def camel_cards do
    File.read!("priv/07_hands_and_bids")
    |> AdventOfCode.CamelCards.answer()
  end

  def camel_cards_with_joker do
    File.read!("priv/07_hands_and_bids")
    |> AdventOfCode.JokerCamelCards.answer()
  end

  def haunted_wastland do
    File.read!("priv/08_desert_map")
    |> AdventOfCode.HauntedWasteland.answer()
  end

  def final_haunted_wastland do
    File.read!("priv/08_desert_map")
    |> AdventOfCode.HauntedWasteland.final_answer()
  end

  def mirage_maintenance do
    File.read!("priv/09_report")
    |> AdventOfCode.MirageMaintenance.answer()
  end

  def final_mirage_maintenance do
    File.read!("priv/09_report")
    |> AdventOfCode.MirageMaintenance.final_answer()
  end
end
