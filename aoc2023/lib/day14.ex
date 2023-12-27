defmodule Aoc2023.Day14 do
  @example """
  O....#....
  O.OO#....#
  .....##...
  OO.#O....O
  .O.....O#.
  O.#..O.#.#
  ..O..#O..O
  .......O..
  #....###..
  #OO..#....
  """

  def solve_upshift_load(file_path \\ nil) do
    file_path
    |> load_input()
    |> parse_input()
    |> upshift_and_rotate_matrix(1)
    |> weight_matrix()
  end

  def solve_rotated_load(file_path \\ nil) do
    file_path
    |> load_input()
    |> parse_input()
    |> upshift_and_rotate_matrix(4_000_000_000)
    |> weight_matrix()
  end

  def load_input(nil), do: @example
  def load_input(file_path), do: File.read!(file_path)

  def parse_input(matrix_str) do
    matrix_str |> String.split("\n", trim: true) |> Enum.map(&to_charlist/1)
  end

  def upshift_and_rotate_matrix(matrix, number_of_times) do
    upshift_and_rotate_matrix(matrix, number_of_times, [])
  end

  def upshift_and_rotate_matrix(matrix, 0, history) do
    {matrix, find_direction(history)}
  end

  def upshift_and_rotate_matrix(matrix, number_of_times, history)
      when rem(length(history), 4) == 3 do
    next_matrix = upshift_and_rotate_matrix(matrix)
    next_history = [matrix | history]
    number_of_times = number_of_times - 1

    found_history_matrix =
      next_history
      |> Enum.with_index(1)
      |> Enum.drop(3)
      |> Enum.take_every(4)
      |> Enum.find(fn {known_matrix, _} -> known_matrix == next_matrix end)

    case found_history_matrix do
      {_, loop_length} ->
        {reversed_loop, history_prefix} = Enum.split(next_history, loop_length)

        final_loop_index = rem(number_of_times, loop_length)
        final_matrix = reversed_loop |> Enum.reverse() |> Enum.at(final_loop_index)
        simplified_history = Enum.take(reversed_loop, final_loop_index) ++ history_prefix
        upshift_and_rotate_matrix(final_matrix, 0, simplified_history)

      nil ->
        upshift_and_rotate_matrix(next_matrix, number_of_times, next_history)
    end
  end

  def upshift_and_rotate_matrix(matrix, number_of_times, history) do
    next_matrix = upshift_and_rotate_matrix(matrix)
    next_history = [matrix | history]
    number_of_times = number_of_times - 1

    upshift_and_rotate_matrix(next_matrix, number_of_times, next_history)
  end

  @doc """
  Rotates the matrix clockwise and puts the `O`s rightmost until
  stopped by a #
  """
  def upshift_and_rotate_matrix(matrix) do
    matrix
    |> rotate_matrix()
    |> Enum.map(&right_shift_barrels/1)
  end

  def find_direction(history) do
    [:north, :west, :south, :east]
    |> Enum.at(rem(length(history), 4))
  end

  def right_shift_barrels(charlist) do
    charlist
    |> List.to_string()
    |> String.split("#")
    |> Enum.map(&right_shift_barrels_in_group/1)
    |> Enum.join("#")
    |> to_charlist()
  end

  def right_shift_barrels_in_group(str) do
    char_frequencies = str |> to_charlist() |> Enum.frequencies()

    List.duplicate(?., char_frequencies[?.] || 0) ++
      List.duplicate(?O, char_frequencies[?O] || 0)
  end

  def weight_matrix({matrix, direction}) do
    matrix |> to_west(direction) |> Enum.map(&weight_load/1) |> Enum.sum()
  end

  def to_west(matrix, direction) do
    {_, number_of_rotations} =
      [:west, :north, :east, :south]
      |> Enum.with_index()
      |> Enum.find(fn {d, _} -> d == direction end)

    if number_of_rotations == 0 do
      matrix
    else
      1..number_of_rotations |> Enum.reduce(matrix, fn _, acc -> rotate_matrix(acc) end)
    end
  end

  def rotate_matrix(matrix), do: matrix |> Enum.reverse() |> transpose_matrix()
  def transpose_matrix(matrix), do: matrix |> Enum.zip() |> Enum.map(&Tuple.to_list/1)

  def weight_load(charlist) do
    charlist
    |> Enum.with_index(1)
    |> Enum.filter(fn {char, _} -> char == ?O end)
    |> Enum.reduce(0, fn {?O, index}, acc -> acc + index end)
  end
end
