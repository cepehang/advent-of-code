defmodule Aoc2023.Day8 do
  @example """
  LLR

  AAA = (BBB, BBB)
  BBB = (AAA, ZZZ)
  ZZZ = (ZZZ, ZZZ)
  """

  def solve_step_count(file_path \\ nil) do
    {directions, map} =
      file_path
      |> load_input()
      |> parse_input()

    directions
    |> get_step_counts_to_end(~r/^AAA$/, ~r/^ZZZ$/, map)
    |> Enum.reduce(1, &lcm/2)
  end

  def solve_ghost_step_count(file_path \\ nil) do
    {directions, map} =
      file_path
      |> load_input()
      |> parse_input()

    directions
    |> get_step_counts_to_end(~r/^..A$/, ~r/^..Z$/, map)
    |> Enum.reduce(1, &lcm/2)
  end

  def load_input(nil), do: @example |> String.trim()
  def load_input(file_path), do: file_path |> File.read!() |> String.trim()

  def parse_input(input) do
    [directions, map_str] = String.split(input, "\n\n")

    map =
      map_str
      |> String.split("\n")
      |> Enum.into(%{}, fn intersection_str ->
        [origin, left, right | _] = String.split(intersection_str, ~r/( = \(|, |\))/)
        {origin, {left, right}}
      end)

    {directions, map}
  end

  def get_step_counts_to_end(directions, starting_positions_regex, end_positions_regex, map) do
    map
    |> Map.keys()
    |> Enum.filter(&String.match?(&1, starting_positions_regex))
    |> Enum.map(&get_step_count_to_end(directions, &1, end_positions_regex, map))
  end

  def get_step_count_to_end(directions, starting_position, end_positions_regex, map) do
    directions
    |> String.to_charlist()
    |> Stream.cycle()
    |> Enum.reduce_while({starting_position, 0}, fn direction, {position, step_count} ->
      if String.match?(position, end_positions_regex) do
        {:halt, step_count}
      else
        {:cont, {next_node(direction, map, position), step_count + 1}}
      end
    end)
  end

  def next_node(?L, map, position) do
    {left, _} = map[position]
    left
  end

  def next_node(?R, map, position) do
    {_, right} = map[position]
    right
  end

  def lcm(a, b), do: div(a * b, gcd(a, b))

  def gcd(a, 0), do: a
  def gcd(0, b), do: b
  def gcd(a, b), do: gcd(b, rem(a, b))
end
