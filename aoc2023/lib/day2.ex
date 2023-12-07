defmodule Aoc2023.Day2.Cubes do
  defstruct red: 0, green: 0, blue: 0
end

defmodule Aoc2023.Day2.Game do
  defstruct id: nil, draws: []
end

defmodule Aoc2023.Day2 do
  alias Aoc2023.Day2.Cubes
  alias Aoc2023.Day2.Game

  @games_str """
  Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
  Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
  Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
  Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
  Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
  """

  @bag %Cubes{red: 12, green: 13, blue: 14}
  def solve_possible_games(file_path \\ nil) do
    input =
      if file_path == nil do
        @games_str
      else
        File.read!(file_path)
      end

    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&parse_game/1)
    |> Enum.filter(&possible_game?(&1, @bag))
    |> Enum.map(&Map.get(&1, :id))
    |> Enum.sum()
  end

  def solve_power_of_cubes(file_path \\ nil) do
    input =
      if file_path == nil do
        @games_str
      else
        File.read!(file_path)
      end

    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&parse_game/1)
    |> Enum.map(&power_of_cubes/1)
    |> Enum.sum()
  end

  def parse_game(game_str) do
    game_str
    |> String.split(": ")
    |> (fn [game_id_str, draws_str] ->
          %Game{
            id:
              game_id_str
              |> (&Regex.run(~r/\d+$/, &1)).()
              |> List.first()
              |> String.to_integer(),
            draws:
              draws_str
              |> String.trim()
              |> String.split("; ")
              |> Enum.map(&parse_draw/1)
          }
        end).()
  end

  def parse_draw(draw_str) do
    draw_str
    |> String.split(", ")
    |> Enum.map(&String.split(&1, " "))
    |> Enum.reduce(
      %Cubes{},
      fn
        [number, "red"], cubes -> Map.put(cubes, :red, String.to_integer(number))
        [number, "green"], cubes -> Map.put(cubes, :green, String.to_integer(number))
        [number, "blue"], cubes -> Map.put(cubes, :blue, String.to_integer(number))
      end
    )
  end

  def possible_game?(%Game{draws: draws}, %Cubes{} = bag) do
    draws
    |> Enum.all?(&possible_draw?(&1, bag))
  end

  def possible_draw?(%Cubes{} = drawn_cubes, %Cubes{} = bag) do
    %Cubes{red: red_drawn, blue: blue_drawn, green: green_drawn} = drawn_cubes
    %Cubes{red: red, blue: blue, green: green} = bag
    red_drawn <= red and blue_drawn <= blue and green_drawn <= green
  end

  def power_of_cubes(%Game{draws: draws}) do
    minimum_bag =
      draws
      |> Enum.reduce(
        %Cubes{},
        fn %Cubes{red: red_drawn, blue: blue_drawn, green: green_drawn},
           %Cubes{red: min_red, blue: min_blue, green: min_green} ->
          %Cubes{
            red: max(red_drawn, min_red),
            green: max(green_drawn, min_green),
            blue: max(blue_drawn, min_blue)
          }
        end
      )

    %Cubes{red: red, green: green, blue: blue} = minimum_bag
    red * green * blue
  end
end
