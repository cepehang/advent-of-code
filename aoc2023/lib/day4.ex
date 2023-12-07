defmodule Aoc2023.Day4 do
  @example """
  Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
  Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
  Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
  Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
  Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
  Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11
  """

  def solve_points(file_path \\ nil) do
    input = load_input(file_path)

    input |> String.split("\n") |> Enum.map(&get_points/1) |> Enum.sum()
  end

  def get_points(card_str) do
    card_str
    |> parse_card()
    |> get_card_points()
  end

  defp get_card_points(%{winning_numbers: winning_numbers, numbers: numbers}) do
    winning_numbers_count = numbers |> Enum.count(&Enum.member?(winning_numbers, &1))

    case winning_numbers_count do
      0 -> 0
      1 -> 1
      n -> 2 ** (n - 1)
    end
  end

  def solve_copies(file_path \\ nil) do
    input = load_input(file_path)

    input |> get_copies() |> Map.values() |> Enum.sum()
  end

  def load_input(), do: String.trim(@example)
  defp load_input(nil), do: String.trim(@example)
  defp load_input(file_path), do: file_path |> File.read!() |> String.trim()

  def get_copies(cards_str) do
    cards_str
    |> String.split("\n")
    |> Enum.map(&parse_card/1)
    |> Enum.reduce(%{}, &reduce_card/2)
  end

  def parse_card(card_str) do
    [game_id_str, game_numbers] = card_str |> String.trim() |> String.split(~r/:\s+/)

    [winning_numbers_str, numbers_str] = String.split(game_numbers, ~r/\s+\|\s+/)

    %{
      id: parse_id(game_id_str),
      winning_numbers: parse_numbers(winning_numbers_str),
      numbers: parse_numbers(numbers_str)
    }
  end

  defp parse_id(id_str) do
    id_str |> String.split(~r/\s+/) |> List.last() |> String.to_integer()
  end

  defp parse_numbers(numbers_str) do
    numbers_str |> String.split(~r/\s+/) |> Enum.map(&String.to_integer/1)
  end

  defp reduce_card(%{id: card_id} = card, %{} = copies) do
    copies = Map.update(copies, card_id, 1, &(&1 + 1))
    count = get_matching_numbers_count(card)

    case count do
      0 ->
        copies

      n ->
        for gained_card_id <- (card_id + 1)..(card_id + n), reduce: copies do
          acc -> Map.update(acc, gained_card_id, copies[card_id], &(&1 + copies[card_id]))
        end
    end
  end

  defp get_matching_numbers_count(%{winning_numbers: winning_numbers, numbers: numbers}) do
    numbers |> Enum.filter(&Enum.member?(winning_numbers, &1)) |> Enum.count()
  end
end
