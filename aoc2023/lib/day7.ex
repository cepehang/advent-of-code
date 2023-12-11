defmodule Aoc2023.Day7 do
  @type_orders %{
    high_card: 1,
    one_pair: 2,
    two_pairs: 3,
    three_of_a_kind: 4,
    full_house: 5,
    four_of_a_kind: 6,
    five_of_a_kind: 7
  }
  @head_values %{
    T: 10,
    J: 11,
    Q: 12,
    K: 13,
    A: 14
  }
  @head_values_with_joker %{
    J: 1,
    T: 10,
    Q: 12,
    K: 13,
    A: 14
  }

  @example """
  32T3K 765
  T55J5 684
  KK677 28
  KTJJT 220
  QQQJA 483
  """

  def solve_weighted_product(file_path \\ nil) do
    file_path
    |> load_input()
    |> parse_input()
    |> Enum.sort_by(fn {hand, _} -> hand end, &compare_hands/2)
    |> Enum.with_index()
    |> Enum.reduce(0, fn {{_, bid}, rank}, acc -> bid * (rank + 1) + acc end)
  end

  def solve_joker_product(file_path \\ nil) do
    file_path
    |> load_input()
    |> parse_input()
    |> Enum.sort_by(fn {hand, _} -> hand end, &compare_hands_with_joker/2)
    |> Enum.with_index()
    |> Enum.reduce(0, fn {{_, bid}, rank}, acc -> bid * (rank + 1) + acc end)
  end

  def load_input(), do: load_input(nil)
  def load_input(nil), do: @example |> String.trim()
  def load_input(file_path), do: file_path |> File.read!() |> String.trim()

  def parse_input(hands_str) do
    hands_str
    |> String.split("\n")
    |> Enum.map(
      &(&1
        |> String.split(~r/\s+/)
        |> (fn [hand, bid_str] -> {hand, String.to_integer(bid_str)} end).())
    )
  end

  def compare_hands(hand_a, hand_b) do
    hand_a_type = get_hand_type(hand_a)
    hand_b_type = get_hand_type(hand_b)

    if hand_a_type != hand_b_type do
      @type_orders[hand_a_type] <= @type_orders[hand_b_type]
    else
      compare_high_cards(hand_a, hand_b)
    end
  end

  def get_hand_type(hand) do
    hand
    |> String.to_charlist()
    |> Enum.frequencies()
    |> Map.values()
    |> Enum.sort(:desc)
    |> match_card_counts()
  end

  def compare_high_cards(hand_a, hand_b) do
    Enum.zip(String.to_charlist(hand_a), String.to_charlist(hand_b))
    |> Enum.map(fn {card_a, card_b} -> get_card_value(card_b) - get_card_value(card_a) end)
    |> Enum.find(0, &(&1 != 0))
    |> (&(&1 >= 0)).()
  end

  def get_card_value(card_value_char) do
    card_value_str = List.to_string([card_value_char])

    if String.match?(card_value_str, ~r/^\d+$/) do
      String.to_integer(card_value_str)
    else
      card_value_str |> String.to_existing_atom() |> (&@head_values[&1]).()
    end
  end

  def compare_hands_with_joker(hand_a, hand_b) do
    hand_a_type = get_hand_type_with_joker(hand_a)
    hand_b_type = get_hand_type_with_joker(hand_b)

    if hand_a_type != hand_b_type do
      @type_orders[hand_a_type] <= @type_orders[hand_b_type]
    else
      compare_high_cards_with_joker(hand_a, hand_b)
    end
  end

  def get_hand_type_with_joker(hand) do
    {joker_frequency, other_card_frequencies} =
      hand
      |> String.to_charlist()
      |> Enum.frequencies()
      |> Enum.split_with(fn {key, _} -> key == ?J end)

    regular_card_counts =
      other_card_frequencies |> Enum.map(fn {_, frequency} -> frequency end) |> Enum.sort(:desc)

    case joker_frequency do
      [] ->
        match_card_counts(regular_card_counts)

      [{_, 5}] ->
        match_card_counts([5])

      [{_, joker_count}] ->
        [most_frequent_card | rest] = regular_card_counts

        match_card_counts([most_frequent_card + joker_count | rest])
    end
  end

  def match_card_counts(card_counts) do
    case card_counts do
      [5] -> :five_of_a_kind
      [4, 1] -> :four_of_a_kind
      [3, 2] -> :full_house
      [3, 1, 1] -> :three_of_a_kind
      [2, 2, 1] -> :two_pairs
      [2, 1, 1, 1] -> :one_pair
      [1, 1, 1, 1, 1] -> :high_card
    end
  end

  def compare_high_cards_with_joker(hand_a, hand_b) do
    Enum.zip(String.to_charlist(hand_a), String.to_charlist(hand_b))
    |> Enum.map(fn {card_a, card_b} ->
      get_card_value_with_joker(card_b) - get_card_value_with_joker(card_a)
    end)
    |> Enum.find(0, &(&1 != 0))
    |> (&(&1 >= 0)).()
  end

  def get_card_value_with_joker(card_value_char) do
    card_value_str = List.to_string([card_value_char])

    if String.match?(card_value_str, ~r/^\d+$/) do
      String.to_integer(card_value_str)
    else
      card_value_str |> String.to_existing_atom() |> (&@head_values_with_joker[&1]).()
    end
  end
end
