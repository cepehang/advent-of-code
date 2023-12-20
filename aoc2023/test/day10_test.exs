defmodule Aoc2023.Day10Test do
  use ExUnit.Case
  import Aoc2023.Day10

  describe "part 1:" do
    test "solve furthest distance" do
      assert solve_furthest_distance() == 8
      assert solve_furthest_distance("test/fixtures/day10.txt") == 6947
    end
  end

  describe "part 2:" do
    test "count enclosed tiles" do
      map =
        parse_input("""
        ..........
        .S------7.
        .|F----7|.
        .||OOOO||.
        .||OOOO||.
        .|L-7F-J|.
        .|II||II|.
        .L--JL--J.
        ..........
        """)

      assert count_enclosed_tiles(map) == 4

      map =
        parse_input("""
        .F----7F7F7F7F-7....
        .|F--7||||||||FJ....
        .||.FJ||||||||L7....
        FJL7L7LJLJ||LJ.L-7..
        L--J.L7...LJS7F-7L7.
        ....F-J..F7FJ|L7L7L7
        ....L7.F7||L7|.L7L7|
        .....|FJLJ|FJ|F7|.LJ
        ....FJL-7.||.||||...
        ....L---J.LJ.LJLJ...
        """)

      assert count_enclosed_tiles(map) == 8

      map =
        parse_input("""
        FF7FSF7F7F7F7F7F---7
        L|LJ||||||||||||F--J
        FL-7LJLJ||||||LJL-77
        F--JF--7||LJLJ7F7FJ-
        L---JF-JLJ.||-FJLJJ7
        |F|F-JF---7F7-L7L|7|
        |FFJF7L7F-JF7|JL---7
        7-L-JL7||F7|L7F-7F7|
        L.L7LFJ|||||FJL7||LJ
        L7JLJL-JLJLJL--JLJ.L
        """)

      assert count_enclosed_tiles(map) == 10
    end

    test "solve enclosed tiles" do
      assert solve_enclosed_tiles("test/fixtures/day10.txt") == 273
    end
  end
end
