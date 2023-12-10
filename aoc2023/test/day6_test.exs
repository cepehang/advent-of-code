defmodule Aoc2023.Day6Test do
  use ExUnit.Case
  import Aoc2023.Day6

  describe "part 1: number of winning strategy count" do
    test "parsing" do
      assert load_input(nil) |> parse_input() == [{7, 9}, {15, 40}, {30, 200}]
    end

    test "winning strategy count" do
      assert count_winning_strategies({7, 9}) == 4
      assert count_winning_strategies({15, 40}) == 8
      assert count_winning_strategies({30, 200}) == 9
    end

    test "multiply counts" do
      assert solve_strategy_count() == 288
      assert solve_strategy_count("test/fixtures/day6.txt") == 281_600
    end
  end

  describe "part 2: big winning strategy count" do
    test "parsing" do
      assert load_input(nil) |> parse_big_race() == {71530, 940_200}
    end

    test "count" do
      assert solve_big_race() == 71503
      assert solve_big_race("test/fixtures/day6.txt") == 33_875_953
    end
  end
end
