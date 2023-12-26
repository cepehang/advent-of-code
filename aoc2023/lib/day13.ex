defmodule Aoc2023.Day13 do
  @example """
  #.##..##.
  ..#.##.#.
  ##......#
  ##......#
  ..#.##.#.
  ..##..##.
  #.#.##.#.

  #...##..#
  #....#..#
  ..##..###
  #####.##.
  #####.##.
  ..##..###
  #....#..#
  """

  def load_input(nil), do: @example
  def load_input(file_path), do: File.read!(file_path)

  def parse_inputs(inputs_str) do
    inputs_str
    |> String.split("\n\n", trim: true)
    |> Enum.map(fn input_str ->
      input_str |> String.split("\n", trim: true) |> Enum.map(&to_charlist/1)
    end)
  end

  def solve_reflection(file_path \\ nil) do
    file_path
    |> load_input()
    |> parse_inputs()
    |> Enum.map(&find_reflection/1)
    |> Enum.reduce(0, fn
      {:horizontal, reflection_index}, acc -> acc + 100 * reflection_index
      {:vertical, reflection_index}, acc -> acc + reflection_index
    end)
  end

  def find_reflection(pattern) do
    horizontal_reflection = find_horizontal_reflection(pattern)

    if horizontal_reflection do
      {:horizontal, horizontal_reflection}
    else
      vertical_reflection = pattern |> transpose_matrix() |> find_horizontal_reflection()
      {:vertical, vertical_reflection}
    end
  end

  def find_horizontal_reflection(pattern) do
    1..(length(pattern) - 1)
    |> Enum.find(&(reflection_distance(&1, pattern) == 0))
  end

  def solve_smudge_reflection(file_path \\ nil) do
    file_path
    |> load_input()
    |> parse_inputs()
    |> Enum.map(&find_smudge_reflection/1)
    |> Enum.reduce(0, fn
      {:horizontal, reflection_index}, acc -> acc + 100 * reflection_index
      {:vertical, reflection_index}, acc -> acc + reflection_index
    end)
  end

  def find_smudge_reflection(pattern) do
    horizontal_reflection = find_smudge_horizontal_reflection(pattern)

    if horizontal_reflection do
      {:horizontal, horizontal_reflection}
    else
      vertical_reflection = pattern |> transpose_matrix() |> find_smudge_horizontal_reflection()
      {:vertical, vertical_reflection}
    end
  end

  def find_smudge_horizontal_reflection(pattern) do
    1..(length(pattern) - 1)
    |> Enum.find(&(reflection_distance(&1, pattern) == 1))
  end

  def reflection_distance(index, pattern) do
    {top, bottom} = Enum.split(pattern, index)

    top
    |> Enum.reverse()
    |> Enum.zip(bottom)
    |> Enum.map(fn {list_a, list_b} -> list_distance(list_a, list_b) end)
    |> Enum.sum()
  end

  def list_distance(list_a, list_b) do
    list_a |> Enum.zip(list_b) |> Enum.reject(fn {a, b} -> a == b end) |> Enum.count()
  end

  def transpose_matrix(matrix), do: matrix |> Enum.zip() |> Enum.map(&Tuple.to_list/1)
end
