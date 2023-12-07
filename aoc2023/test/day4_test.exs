defmodule Aoc2023.Day4Test do
  use ExUnit.Case
  import Aoc2023.Day4

  test "points" do
    assert get_points("Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53") == 8
    assert get_points("Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19") == 2
    assert get_points("Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1") == 2
    assert get_points("Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83") == 1
    assert get_points("Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36") == 0
    assert get_points("Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11") == 0
  end

  test "points sum" do
    assert solve_points() == 13
    assert solve_points("test/fixtures/day4.txt") == 25004
  end

  test "cards copy" do
    assert get_copies(load_input()) == %{1 => 1, 2 => 2, 3 => 4, 4 => 8, 5 => 14, 6 => 1}
  end

  test "cards copy sum" do
    assert solve_copies() == 30
    assert solve_copies("test/fixtures/day4.txt") == 14_427_616
  end
end
