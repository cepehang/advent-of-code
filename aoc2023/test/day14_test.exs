defmodule Aoc2023.Day14Test do
  use ExUnit.Case
  import Aoc2023.Day14

  describe "part 1:" do
    test "upshift load sum" do
      assert solve_upshift_load() == 136
      assert solve_upshift_load("test/fixtures/day14.txt") == 107_053
    end
  end

  describe "part 2:" do
    test "rotate load" do
      {matrix, :north} = nil |> load_input() |> parse_input() |> upshift_and_rotate_matrix(4)

      assert matrix == [
               ~c".....#....",
               ~c"....#...O#",
               ~c"...OO##...",
               ~c".OO#......",
               ~c".....OOO#.",
               ~c".O#...O#.#",
               ~c"....O#....",
               ~c"......OOOO",
               ~c"#...O###..",
               ~c"#..OO#...."
             ]

      {matrix, :north} = nil |> load_input() |> parse_input() |> upshift_and_rotate_matrix(8)

      assert matrix == [
               ~c".....#....",
               ~c"....#...O#",
               ~c".....##...",
               ~c"..O#......",
               ~c".....OOO#.",
               ~c".O#...O#.#",
               ~c"....O#...O",
               ~c".......OOO",
               ~c"#..OO###..",
               ~c"#.OOO#...O"
             ]

      {matrix, :north} = nil |> load_input() |> parse_input() |> upshift_and_rotate_matrix(12)

      assert matrix == [
               ~c".....#....",
               ~c"....#...O#",
               ~c".....##...",
               ~c"..O#......",
               ~c".....OOO#.",
               ~c".O#...O#.#",
               ~c"....O#...O",
               ~c".......OOO",
               ~c"#...O###.O",
               ~c"#.OOO#...O"
             ]
    end

    test "rotated load sum" do
      assert solve_rotated_load() == 64
      assert solve_rotated_load("test/fixtures/day14.txt") == 88371
    end
  end
end
