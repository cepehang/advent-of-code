defmodule Aoc2023.Day5Test do
  use ExUnit.Case
  import Aoc2023.Day5

  describe "part 1: seed scalars" do
    test "seed conversion" do
      input = """
      seeds: 79 14 55 13

      seed-to-soil map:
      50 98 2
      52 50 48
      """

      {seeds, [conversion_map]} = input |> String.trim() |> parse_input()

      assert reduce_conversion_map_to_seeds(conversion_map, seeds) == [81, 14, 57, 13]
    end

    test "seed map conversions" do
      # assert solve_map_conversions() == 35
      assert solve_map_conversions("test/fixtures/day5.txt") == 535_088_217
    end
  end

  describe "part 2: seed ranges" do
    test "next seed ranges" do
      assert next_seed_ranges([{1, 3, 5}], {4, 3}) == [{2, 3}]
      assert next_seed_ranges([{1, 2, 3}], {3, 5}) == [{2, 2}, {5, 3}]
      assert next_seed_ranges([{100, 2, 3}], {1, 7}) == [{100, 3}, {1, 1}, {5, 3}]
      assert next_seed_ranges([{100, 2, 3}], {1, 2}) == [{100, 1}, {1, 1}]
      assert next_seed_ranges([{100, 2, 3}], {9, 2}) == [{9, 2}]
      assert next_seed_ranges([{100, 9, 2}], {2, 3}) == [{2, 3}]
      assert next_seed_ranges([{45, 77, 23}, {81, 45, 19}, {68, 64, 13}], {77, 1}) == [{45, 1}]
    end

    test "shift seeds" do
      assert shift_seed_range({0, 3, 1}, {4, 1}) == []
      assert shift_seed_range({0, 3, 1}, {2, 1}) == []
      assert shift_seed_range({0, 3, 3}, {3, 3}) == [{0, 3}]
      assert shift_seed_range({0, 3, 3}, {2, 3}) == [{0, 2}]
      assert shift_seed_range({0, 3, 3}, {4, 3}) == [{1, 2}]
      assert shift_seed_range({0, 4, 1}, {3, 3}) == [{0, 1}]
      assert shift_seed_range({1, 3, 5}, {4, 3}) == [{2, 3}]
      assert shift_seed_range({45, 77, 23}, {77, 1}) == [{45, 1}]
    end

    test "scan unshifted seeds" do
      assert scan_unshifted_seed_range({0, 3, 1}, {4, 1}) == [{4, 1}]
      assert scan_unshifted_seed_range({0, 3, 1}, {2, 1}) == [{2, 1}]
      assert scan_unshifted_seed_range({0, 3, 3}, {3, 3}) == []
      assert scan_unshifted_seed_range({0, 3, 3}, {2, 3}) == [{2, 1}]
      assert scan_unshifted_seed_range({0, 3, 3}, {4, 3}) == [{6, 1}]
      assert scan_unshifted_seed_range({0, 4, 1}, {3, 3}) == [{3, 1}, {5, 1}]
    end

    test "range conversions" do
      assert solve_range_conversions() == 46
      assert solve_range_conversions("test/fixtures/day5.txt") == 51_399_228
    end
  end
end
