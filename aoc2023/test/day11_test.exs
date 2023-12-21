defmodule Aoc2023.Day11Test do
  use ExUnit.Case
  import Aoc2023.Day11

  describe "part 1:" do
    test "solve padded manhattan distances" do
      assert solve_expanded_distance(nil, 2) == 374
      assert solve_expanded_distance("test/fixtures/day11.txt", 2) == 10_154_062
    end
  end

  describe "part 2:" do
    test "solve padded manhattan distances" do
      assert solve_expanded_distance(nil, 10) == 1030
      assert solve_expanded_distance(nil, 100) == 8410
      assert solve_expanded_distance("test/fixtures/day11.txt", 1_000_000) == 553_083_047_914
    end
  end
end
