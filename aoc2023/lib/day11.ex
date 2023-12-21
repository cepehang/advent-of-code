defmodule Aoc2023.Day11 do
  @example """
  ...#......
  .......#..
  #.........
  ..........
  ......#...
  .#........
  .........#
  ..........
  .......#..
  #...#.....
  """

  def load_input(nil), do: @example
  def load_input(file_path), do: File.read!(file_path)

  def solve_expanded_distance(file_path \\ nil, expansion_factor \\ 1) do
    charlist_matrix =
      file_path
      |> load_input()
      |> to_charlist_matrix()

    hashtag_coordinates = find_hashtag_coordinates(charlist_matrix)
    expanding_row_indexes = find_expanding_row_indexes(charlist_matrix)
    expanding_col_indexes = find_expanding_col_indexes(charlist_matrix)

    hashtag_coordinates
    |> compute_hashtag_distances(expansion_factor, {expanding_row_indexes, expanding_col_indexes})
    |> Enum.sum()
  end

  def to_charlist_matrix(map_str) do
    map_str
    |> String.split("\n", trim: true)
    |> Enum.map(&to_charlist/1)
  end

  def find_hashtag_coordinates(charlist_matrix) do
    charlist_matrix
    |> Enum.with_index()
    |> Enum.flat_map(fn {charlist, row_index} ->
      charlist
      |> Enum.with_index()
      |> Enum.filter(fn {char, _} -> char == ?# end)
      |> Enum.map(fn {_, col_index} -> {row_index, col_index} end)
    end)
  end

  def find_expanding_col_indexes(charlist_matrix) do
    charlist_matrix
    |> Enum.zip()
    |> Enum.map(&Tuple.to_list/1)
    |> find_expanding_row_indexes()
  end

  def find_expanding_row_indexes(charlist_matrix) do
    charlist_matrix
    |> Enum.with_index()
    |> Enum.filter(fn {charlist, _} -> Enum.all?(charlist, &(&1 == ?.)) end)
    |> Enum.map(fn {_, row_index} -> row_index end)
  end

  def compute_hashtag_distances([], _, _), do: []

  def compute_hashtag_distances(
        [coordinates | coordinates_tail],
        expansion_factor,
        expanding_indexes
      ) do
    distances =
      coordinates_tail
      |> Enum.map(fn coordinates_b ->
        compute_distance(coordinates, coordinates_b, expansion_factor, expanding_indexes)
      end)

    distances ++ compute_hashtag_distances(coordinates_tail, expansion_factor, expanding_indexes)
  end

  def compute_distance(
        {row_index_a, col_index_a},
        {row_index_b, col_index_b},
        expansion_factor,
        {expanding_row_indexes, expanding_col_indexes}
      ) do
    manhattan_distance = abs(row_index_b - row_index_a) + abs(col_index_b - col_index_a)

    crossed_expanding_row_count =
      expanding_row_indexes
      |> Enum.filter(&(&1 in row_index_a..row_index_b))
      |> Enum.count()

    crossed_expanding_col_count =
      expanding_col_indexes
      |> Enum.filter(&(&1 in col_index_a..col_index_b))
      |> Enum.count()

    expansion =
      (crossed_expanding_row_count + crossed_expanding_col_count) * (expansion_factor - 1)

    manhattan_distance + expansion
  end
end
