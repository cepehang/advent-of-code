defmodule Aoc2023.Day1Test do
  use ExUnit.Case
  alias Aoc2023.Day1

  test "digits solving" do
    assert Day1.solve_digits() == 142
    assert Day1.solve_digits("test/fixtures/day1.txt") == 55029
  end

  test "digits and words extraction" do
    assert Day1.extract_first_and_last_digits_or_words("two1nine") == 29
    assert Day1.extract_first_and_last_digits_or_words("eightwothree") == 83
    assert Day1.extract_first_and_last_digits_or_words("abcone2threexyz") == 13
    assert Day1.extract_first_and_last_digits_or_words("xtwone3four") == 24
    assert Day1.extract_first_and_last_digits_or_words("4nineeightseven2") == 42
    assert Day1.extract_first_and_last_digits_or_words("zoneight234") == 14
    assert Day1.extract_first_and_last_digits_or_words("7pqrstsixteen") == 76
    assert Day1.extract_first_and_last_digits_or_words("seventgb4ninefive29twonegnb") == 71
  end

  test "digits and words solving" do
    assert Day1.solve_digits_and_words() == 281
    assert Day1.solve_digits_and_words("test/fixtures/day1.txt") == 55686
  end
end
