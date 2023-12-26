defmodule Aoc2023.Day13Test do
  use ExUnit.Case
  import Aoc2023.Day13

  describe "part 1:" do
    test "find horizontal reflection" do
      input = [
        #  12345<789
        ~c"#.##..##.",
        ~c"..#.##.#.",
        ~c"##......#",
        ~c"##......#",
        ~c"..#.##.#.",
        ~c"..##..##.",
        ~c"#.#.##.#."
      ]

      assert find_reflection(input) == {:vertical, 5}
    end

    test "find vertical reflection" do
      input = [
        ~c"#...##..#",
        ~c"#....#..#",
        ~c"..##..###",
        ~c"#####.##.",
        ~c"#####.##.",
        ~c"..##..###",
        ~c"#....#..#"
      ]

      assert find_reflection(input) == {:horizontal, 4}
    end

    test "weighted sum" do
      assert solve_reflection() == 405
      assert solve_reflection("test/fixtures/day13.txt") == 33047
    end
  end

  describe "part 2: with smudge" do
    test "find horizontal reflection" do
      input = [
        ~c"#.##..##.",
        ~c"..#.##.#.",
        ~c"##......#",
        ~c"##......#",
        ~c"..#.##.#.",
        ~c"..##..##.",
        ~c"#.#.##.#."
      ]

      assert find_smudge_reflection(input) == {:horizontal, 3}
    end

    test "find vertical reflection" do
      input = [
        ~c"#...##..#",
        ~c"#....#..#",
        ~c"..##..###",
        ~c"#####.##.",
        ~c"#####.##.",
        ~c"..##..###",
        ~c"#....#..#"
      ]

      assert find_smudge_reflection(input) == {:horizontal, 1}
    end

    test "weighted sum" do
      assert solve_smudge_reflection() == 400
      assert solve_smudge_reflection("test/fixtures/day13.txt") == 28806
    end
  end
end
