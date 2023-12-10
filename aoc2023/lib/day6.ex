defmodule Aoc2023.Day6 do
  @example """
  Time:      7  15   30
  Distance:  9  40  200
  """

  def solve_strategy_count(file_path \\ nil) do
    load_input(file_path)
    |> parse_input()
    |> Stream.map(&count_winning_strategies/1)
    |> Enum.product()
  end

  def load_input(nil), do: @example
  def load_input(file_path), do: File.read!(file_path)

  def parse_input(str) do
    [times_str, distances_str | _] = String.split(str, "\n")
    times = times_str |> String.split(~r/\s+/) |> Stream.drop(1) |> Enum.map(&String.to_integer/1)

    distances =
      distances_str |> String.split(~r/\s+/) |> Stream.drop(1) |> Enum.map(&String.to_integer/1)

    Enum.zip(times, distances)
  end

  def solve_big_race(file_path \\ nil) do
    load_input(file_path)
    |> parse_big_race()
    |> count_winning_strategies()
  end

  def parse_big_race(str) do
    [time_str, distance_str | _] = String.split(str, "\n")

    time =
      time_str
      |> String.split(~r/\s+/, parts: 2)
      |> List.last()
      |> String.replace(~r/\s+/, "")
      |> String.to_integer()

    distance =
      distance_str
      |> String.split(~r/\s+/, parts: 2)
      |> List.last()
      |> String.replace(~r/\s+/, "")
      |> String.to_integer()

    {time, distance}
  end

  def count_winning_strategies({time, record_distance}) do
    1..(time - 1)
    |> Stream.map(fn charge_time -> charge_time * (time - charge_time) end)
    |> Stream.filter(fn distance -> distance > record_distance end)
    |> Enum.count()
  end
end
