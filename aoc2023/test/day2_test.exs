defmodule Aoc2023.Day2Test do
  use ExUnit.Case
  import Aoc2023.Day2
  alias Aoc2023.Day2.Cubes
  alias Aoc2023.Day2.Game

  @bag %Cubes{red: 12, green: 13, blue: 14}
  @game1 %Game{
    id: 1,
    draws: [
      %Cubes{red: 4, blue: 3},
      %Cubes{red: 1, green: 2, blue: 6},
      %Cubes{green: 2}
    ]
  }
  @game2 %Game{
    id: 2,
    draws: [
      %Cubes{green: 2, blue: 1},
      %Cubes{red: 1, green: 3, blue: 4},
      %Cubes{green: 1, blue: 1}
    ]
  }
  @game3 %Game{
    id: 3,
    draws: [
      %Cubes{red: 20, green: 8, blue: 6},
      %Cubes{red: 4, green: 13, blue: 5},
      %Cubes{red: 1, green: 5, blue: 5}
    ]
  }
  @game4 %Game{
    id: 4,
    draws: [
      %Cubes{red: 3, green: 1, blue: 6},
      %Cubes{red: 6, green: 3},
      %Cubes{red: 14, green: 3, blue: 15}
    ]
  }
  @game5 %Game{
    id: 5,
    draws: [
      %Cubes{red: 6, green: 3, blue: 1},
      %Cubes{red: 1, green: 2, blue: 2}
    ]
  }

  test "possible game detection" do
    assert possible_game?(@game1, @bag)
    assert possible_game?(@game2, @bag)
    assert possible_game?(@game5, @bag)
  end

  test "impossible game detection" do
    assert not possible_game?(@game3, @bag)
    assert not possible_game?(@game4, @bag)
  end

  test "possible games id sum" do
    assert solve_possible_games() == 8
    assert solve_possible_games("test/fixtures/day2.txt") == 2683
  end

  test "power of cubes" do
    assert power_of_cubes(@game1) == 48
    assert power_of_cubes(@game2) == 12
    assert power_of_cubes(@game3) == 1560
    assert power_of_cubes(@game4) == 630
    assert power_of_cubes(@game5) == 36
  end

  test "power of cubes sum" do
    assert solve_power_of_cubes() == 2286
    assert solve_power_of_cubes("test/fixtures/day2.txt") == 49710
  end
end
