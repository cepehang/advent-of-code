defmodule Aoc2023.Day8Test do
  use ExUnit.Case
  import Aoc2023.Day8

  describe "part 1: find exit" do
    test "next node" do
      map = %{"AAA" => {"BBB", "CCC"}}
      assert next_node(?L, map, "AAA") == "BBB"
      assert next_node(?R, map, "AAA") == "CCC"
    end

    test "step count" do
      assert solve_step_count() == 6
      assert solve_step_count("test/fixtures/day8.txt") == 15517
    end
  end

  describe "part 2: find simultaneous exits" do
    test "step count" do
      assert solve_ghost_step_count() == 6
      assert solve_ghost_step_count("test/fixtures/day8.txt") == 14_935_034_899_483
    end
  end
end
