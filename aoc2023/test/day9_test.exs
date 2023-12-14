defmodule Aoc2023.Day9Test do
  use ExUnit.Case
  import Aoc2023.Day9

  describe "part 1: next" do
    test "history extrapolation" do
      assert extrapolate_next([0, 3, 6, 9, 12, 15]) == 18
      assert extrapolate_next([1, 3, 6, 10, 15, 21]) == 28
      assert extrapolate_next([10, 13, 16, 21, 30, 45]) == 68
    end

    test "extrapolation sum" do
      assert solve_next_extrapolation() == 114
      assert solve_next_extrapolation("test/fixtures/day9.txt") == 2_038_472_161
    end
  end

  describe "part 2: prev" do
    test "history extrapolation" do
      assert extrapolate_prev([0, 3, 6, 9, 12, 15]) == -3
      assert extrapolate_prev([1, 3, 6, 10, 15, 21]) == 0
      assert extrapolate_prev([10, 13, 16, 21, 30, 45]) == 5
    end

    test "extrapolation sum" do
      assert solve_prev_extrapolation() == 2
      assert solve_prev_extrapolation("test/fixtures/day9.txt") == 1091
    end
  end
end
