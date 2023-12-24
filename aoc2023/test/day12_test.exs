defmodule Aoc2023.Day12Test do
  use ExUnit.Case
  import Aoc2023.Day12

  describe "part 1:" do
    test "possible arrangements computation" do
      :ets.new(:memo, [:set, :protected, :named_table])
      assert count_possible_arrangements(~c"???.###", [1, 1, 3]) == 1
      assert count_possible_arrangements(~c".??..??...?##.", [1, 1, 3]) == 4
      assert count_possible_arrangements(~c"?#?#?#?#?#?#?#?", [1, 3, 1, 6]) == 1
      assert count_possible_arrangements(~c"????.#...#...", [4, 1, 1]) == 1
      assert count_possible_arrangements(~c"????.######..#####.", [1, 6, 5]) == 4
      assert count_possible_arrangements(~c"?###????????", [3, 2, 1]) == 10
      assert count_possible_arrangements(~c"???#??#?#?#?..", [1, 7]) == 1
      assert count_possible_arrangements(~c"?.?#.?.#???..?", [1, 4]) == 1
      :ets.delete(:memo)
    end

    test "possible arrangements count" do
      assert solve_matching_arrangements() == 21
      assert solve_matching_arrangements("test/fixtures/day12.txt") == 7857
    end
  end

  describe "part 2: with unfolding" do
    test "possible arrangements computation" do
      :ets.new(:memo, [:set, :protected, :named_table])
      assert unfold_and_count_possible_arrangements(~c"???.###", [1, 1, 3]) == 1
      assert unfold_and_count_possible_arrangements(~c".??..??...?##.", [1, 1, 3]) == 16384
      assert unfold_and_count_possible_arrangements(~c"?#?#?#?#?#?#?#?", [1, 3, 1, 6]) == 1
      assert unfold_and_count_possible_arrangements(~c"????.#...#...", [4, 1, 1]) == 16
      assert unfold_and_count_possible_arrangements(~c"????.######..#####.", [1, 6, 5]) == 2500
      assert unfold_and_count_possible_arrangements(~c"?###????????", [3, 2, 1]) == 506_250
      :ets.delete(:memo)
    end

    test "possible arrangements count" do
      assert solve_unfolded_arrangements() == 525_152
      assert solve_unfolded_arrangements("test/fixtures/day12.txt") == 28_606_137_449_920
    end
  end
end
