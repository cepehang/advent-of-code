defmodule Aoc2023.Day9 do
  @example """
  0 3 6 9 12 15
  1 3 6 10 15 21
  10 13 16 21 30 45
  """

  def solve_next_extrapolation(file_path \\ nil) do
    file_path |> load_input() |> parse_input() |> Enum.map(&extrapolate_next/1) |> Enum.sum()
  end

  def solve_prev_extrapolation(file_path \\ nil) do
    file_path |> load_input() |> parse_input() |> Enum.map(&extrapolate_prev/1) |> Enum.sum()
  end

  def load_input(nil), do: @example
  def load_input(file_path), do: File.read!(file_path)

  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn history_str ->
      history_str |> String.split(~r/\s+/, trim: true) |> Enum.map(&String.to_integer/1)
    end)
  end

  def extrapolate_next(history) do
    history
    |> (&derivate_until_constant([&1])).()
    |> Enum.reduce(0, fn derivated_history, derivated_next ->
      derivated_next + List.last(derivated_history)
    end)
  end

  def extrapolate_prev(history) do
    history
    |> (&derivate_until_constant([&1])).()
    |> Enum.reduce(0, fn [derivated_cur | _], derivated_prev -> derivated_cur - derivated_prev end)
  end

  def derivate_until_constant([cur | _] = derivated_histories) do
    next_derivated_history = derivate(cur)
    next_derivated_histories = [next_derivated_history | derivated_histories]

    if Enum.all?(next_derivated_history, &(&1 == 0)) do
      next_derivated_histories
    else
      derivate_until_constant(next_derivated_histories)
    end
  end

  def derivate(history) do
    history
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.map(fn [a, b] -> b - a end)
  end
end
