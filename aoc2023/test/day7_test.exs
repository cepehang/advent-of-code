defmodule Aoc2023.Day7Test do
  use ExUnit.Case
  import Aoc2023.Day7

  describe "part 1" do
    test "hand type detection" do
      assert get_hand_type("32T3K") == :one_pair
      assert get_hand_type("T55J5") == :three_of_a_kind
      assert get_hand_type("KK677") == :two_pairs
      assert get_hand_type("KTJJT") == :two_pairs
      assert get_hand_type("QQQJA") == :three_of_a_kind
      assert get_hand_type("2A4JA") == :one_pair
      assert get_hand_type("2A2A2") == :full_house
      assert get_hand_type("222J2") == :four_of_a_kind
    end

    test "hand sorting" do
      assert Enum.sort(["32T3K", "T55J5", "KK677", "KTJJT", "QQQJA"], &compare_hands/2) == [
               "32T3K",
               "KTJJT",
               "KK677",
               "T55J5",
               "QQQJA"
             ]
    end

    test "solve weighted product" do
      assert solve_weighted_product() == 6440
      assert solve_weighted_product("test/fixtures/day7.txt") == 252_052_080
    end
  end

  describe "part 2: jokers" do
    test "hand type detection with jokers" do
      assert get_hand_type_with_joker("32T3K") == :one_pair
      assert get_hand_type_with_joker("T55J5") == :four_of_a_kind
      assert get_hand_type_with_joker("KK677") == :two_pairs
      assert get_hand_type_with_joker("KTJJT") == :four_of_a_kind
      assert get_hand_type_with_joker("QQQJA") == :four_of_a_kind
      assert get_hand_type_with_joker("2A4JA") == :three_of_a_kind
      assert get_hand_type_with_joker("2A2A2") == :full_house
      assert get_hand_type_with_joker("222J2") == :five_of_a_kind
    end

    test "hand sorting" do
      assert Enum.sort(
               ["32T3K", "T55J5", "KK677", "KTJJT", "QQQJA"],
               &compare_hands_with_joker/2
             ) == ["32T3K", "KK677", "T55J5", "QQQJA", "KTJJT"]
    end

    test "solve weighted product" do
      assert solve_joker_product() == 5905
      assert solve_joker_product("test/fixtures/day7.txt") == 253_019_563
    end
  end
end
