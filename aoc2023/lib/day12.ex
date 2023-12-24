defmodule Aoc2023.Day12 do
  @example """
  ???.### 1,1,3
  .??..??...?##. 1,1,3
  ?#?#?#?#?#?#?#? 1,3,1,6
  ????.#...#... 4,1,1
  ????.######..#####. 1,6,5
  ?###???????? 3,2,1
  """

  def solve_matching_arrangements(file_path \\ nil) do
    :ets.new(:memo, [:set, :protected, :named_table])

    count =
      file_path
      |> load_input()
      |> parse_input()
      |> Enum.map(fn {condition, criteria} -> count_possible_arrangements(condition, criteria) end)
      |> Enum.sum()

    :ets.delete(:memo)
    count
  end

  def solve_unfolded_arrangements(file_path \\ nil) do
    :ets.new(:memo, [:set, :protected, :named_table])

    count =
      file_path
      |> load_input()
      |> parse_input()
      |> Enum.map(fn {condition, criteria} ->
        unfold_and_count_possible_arrangements(condition, criteria)
      end)
      |> Enum.sum()

    :ets.delete(:memo)
    count
  end

  def load_input(nil), do: @example
  def load_input(file_path), do: File.read!(file_path)

  def parse_input(records_str) do
    records_str
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_record/1)
  end

  def parse_record(record_str) do
    [condition, criteria] = String.split(record_str, " ")
    {to_charlist(condition), criteria |> String.split(",") |> Enum.map(&String.to_integer/1)}
  end

  def unfold_and_count_possible_arrangements(condition, criteria) do
    {unfolded_condition, unfolded_criteria} = unfold_record(condition, criteria)
    count = count_possible_arrangements(unfolded_condition, unfolded_criteria)
    count
  end

  def unfold_record(condition, criteria) do
    {condition |> List.duplicate(5) |> Enum.intersperse([??]) |> List.flatten(),
     criteria |> List.duplicate(5) |> List.flatten()}
  end

  def count_possible_arrangements([], [_head | _tail]) do
    0
  end

  def count_possible_arrangements(condition, []) do
    if condition |> Enum.map(&can_be_dot?/1) |> Enum.all?() do
      1
    else
      0
    end
  end

  def count_possible_arrangements([?. | _] = condition, criteria) do
    key = {condition, criteria}

    case :ets.lookup(:memo, key) do
      [{^key, count}] ->
        count

      [] ->
        count = condition |> Enum.drop_while(&(&1 == ?.)) |> count_possible_arrangements(criteria)
        :ets.insert(:memo, {key, count})
        count
    end
  end

  def count_possible_arrangements(condition, [current_criteria | criteria_tail] = criteria) do
    key = {condition, criteria}

    case :ets.lookup(:memo, key) do
      [{^key, count}] ->
        count

      [] ->
        current_condition = Enum.take(condition, current_criteria)
        current_condition_length = length(current_condition)

        count =
          cond do
            current_condition_length < current_criteria ->
              0

            not (current_condition |> Enum.map(&can_be_hashtag/1) |> Enum.all?()) ->
              if hd(condition) == ?# do
                0
              else
                condition
                |> Enum.drop_while(&(&1 == ??))
                |> count_possible_arrangements(criteria)
              end

            length(condition) == current_criteria ->
              count_possible_arrangements([], criteria_tail)

            not (condition |> Enum.at(current_condition_length) |> can_be_dot?()) ->
              if hd(condition) == ?# do
                0
              else
                condition
                |> tl()
                |> count_possible_arrangements(criteria)
              end

            true ->
              leading_criteria_arrangements_count =
                condition
                |> Enum.drop(current_condition_length + 1)
                |> count_possible_arrangements(criteria_tail)

              if hd(condition) == ?# do
                leading_criteria_arrangements_count
              else
                leading_dot_arrangements_count =
                  condition
                  |> tl()
                  |> count_possible_arrangements(criteria)

                leading_criteria_arrangements_count +
                  leading_dot_arrangements_count
              end
          end

        :ets.insert(:memo, {key, count})
        count
    end
  end

  def can_be_dot?(char), do: char == ?? or char == ?.
  def can_be_hashtag(char), do: char == ?? or char == ?#

  # naive brute force implementation
  def compute_possible_arrangements({condition, criteria}) do
    condition
    |> length()
    |> compute_possible_arrangements(criteria)
    |> Enum.filter(&satisfies_condition?(&1, condition))
  end

  def compute_possible_arrangements(length, []), do: [List.duplicate(?., length)]
  def compute_possible_arrangements(0, _), do: []

  def compute_possible_arrangements(length, [group_length | group_lengths_tail] = group_lengths) do
    needed_padding = length(group_lengths) - 1

    if length == Enum.sum(group_lengths) + needed_padding do
      [
        group_lengths
        |> Enum.map_intersperse([?.], &List.duplicate(?#, &1))
        |> List.flatten()
      ]
    else
      leading_group_arrangements =
        (length - group_length - 1)
        |> compute_possible_arrangements(group_lengths_tail)
        |> Enum.map(&(List.duplicate(?#, group_length) ++ [?.] ++ &1))

      other_group_arrangements =
        (length - 1)
        |> compute_possible_arrangements(group_lengths)
        |> Enum.map(&([?.] ++ &1))

      leading_group_arrangements ++ other_group_arrangements
    end
  end

  def satisfies_condition?(arrangement, condition)
      when length(arrangement) != length(condition) do
    false
  end

  def satisfies_condition?(arrangement, condition) do
    arrangement
    |> Enum.zip(condition)
    |> Enum.map(fn
      {_, ??} -> true
      {arrangement_char, condition_char} -> arrangement_char == condition_char
    end)
    |> Enum.all?()
  end
end
