defmodule Aoc2023.Day3 do
  @engine_schematic """
  467..114..
  ...*......
  ..35..633.
  ......#...
  617*......
  .....+.58.
  ..592.....
  ......755.
  ...$.*....
  .664.598..
  """

  def example_engine_schematic() do
    @engine_schematic
  end

  def solve_parts_numbers(file_path \\ nil) do
    file_path
    |> load_input()
    |> String.split("\n")
    |> find_parts_numbers()
    |> Enum.sum()
  end

  defp load_input(nil), do: @engine_schematic
  defp load_input(file_path), do: File.read!(file_path)

  defmodule SchematicParser do
    defstruct cur_symbol_positions: [],
              next_row_str: "",
              parts_numbers: []
  end

  def find_parts_numbers(engine_schematic_str) do
    %SchematicParser{parts_numbers: parts_numbers} =
      engine_schematic_str
      |> Enum.reduce(%SchematicParser{}, &reduce_schematic_row/2)

    parts_numbers
  end

  defp reduce_schematic_row(
         next_row_str,
         %SchematicParser{
           cur_symbol_positions: prev_symbol_positions,
           next_row_str: cur_row_str,
           parts_numbers: parts_numbers
         } = parser
       ) do
    cur_symbol_positions = find_positions(cur_row_str, ~r/[^0-9.]/)
    next_symbol_positions = find_positions(next_row_str, ~r/[^0-9.]/)

    symbol_positions =
      prev_symbol_positions ++ cur_symbol_positions ++ next_symbol_positions

    cur_parts_numbers =
      cur_row_str
      |> find_matches(~r/\d+/)
      |> Enum.filter(&contains_any_position?(&1, symbol_positions))
      |> Enum.map(&read_number(&1, cur_row_str))

    %SchematicParser{
      parser
      | cur_symbol_positions: cur_symbol_positions,
        next_row_str: next_row_str,
        parts_numbers: cur_parts_numbers ++ parts_numbers
    }
  end

  defp contains_any_position?({byte_index, match_length}, positions) do
    adjacent_positions_range = max(0, byte_index - 1)..(byte_index + match_length)

    positions
    |> Enum.map(&Enum.member?(adjacent_positions_range, &1))
    |> Enum.any?()
  end

  def solve_gear_ratios(file_path \\ nil) do
    input = if is_nil(file_path), do: @engine_schematic, else: File.read!(file_path)

    input
    |> String.split("\n")
    |> find_gear_ratios()
    |> Enum.sum()
  end

  defmodule GearParser do
    defstruct cur_row_str: "",
              next_row_str: "",
              gear_ratios: []
  end

  def find_gear_ratios(engine_schematic_str) do
    %GearParser{gear_ratios: gear_ratios} =
      engine_schematic_str
      |> Enum.reduce(%GearParser{}, &reduce_gear_row/2)

    gear_ratios
  end

  defp reduce_gear_row(
         next_row_str,
         %{
           cur_row_str: prev_row_str,
           next_row_str: cur_row_str,
           gear_ratios: gear_ratios
         } = parser
       ) do
    cur_symbol_positions = find_positions(cur_row_str, ~r/\*/)

    prev_numbers_matches = find_matches(prev_row_str, ~r/\d+/)
    cur_numbers_matches = find_matches(cur_row_str, ~r/\d+/)
    next_numbers_matches = find_matches(next_row_str, ~r/\d+/)

    cur_gear_ratios =
      for symbol_position <- cur_symbol_positions do
        prev_adjacent_numbers =
          get_adjacent_numbers(prev_numbers_matches, symbol_position, prev_row_str)

        cur_adjacent_numbers =
          get_adjacent_numbers(cur_numbers_matches, symbol_position, cur_row_str)

        next_adjacent_numbers =
          get_adjacent_numbers(next_numbers_matches, symbol_position, next_row_str)

        adjacent_numbers = prev_adjacent_numbers ++ cur_adjacent_numbers ++ next_adjacent_numbers

        case adjacent_numbers do
          [a, b] -> a * b
          _ -> 0
        end
      end

    %GearParser{
      parser
      | cur_row_str: cur_row_str,
        next_row_str: next_row_str,
        gear_ratios: gear_ratios ++ cur_gear_ratios
    }
  end

  defp find_positions(str, regex) do
    regex
    |> Regex.scan(str, return: :index)
    |> Enum.map(fn [{byte_index, _match_length}] -> byte_index end)
  end

  defp find_matches(str, regex) do
    regex
    |> Regex.scan(str, return: :index)
    |> Enum.flat_map(&Function.identity/1)
  end

  defp get_adjacent_numbers(matches, position, str) do
    matches
    |> Enum.filter(&contains_position?(&1, position))
    |> Enum.map(&read_number(&1, str))
  end

  defp contains_position?({byte_index, match_length}, position) do
    adjacent_positions_range = max(0, byte_index - 1)..(byte_index + match_length)
    Enum.member?(adjacent_positions_range, position)
  end

  defp read_number({byte_index, match_length}, str) do
    str |> String.slice(byte_index, match_length) |> String.to_integer()
  end
end
