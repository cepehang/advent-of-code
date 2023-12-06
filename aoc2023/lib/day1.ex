defmodule Aoc2023.Day1 do
  def solve_digits(file_path \\ nil) do
    input =
      if file_path == nil do
        """
        1abc2
        pqr3stu8vwx
        a1b2c3d4e5f
        treb7uchet
        """
      else
        File.read!(file_path)
      end

    input
    |> String.trim()
    |> String.split("\n")
    |> Stream.map(&extract_first_and_last_digits/1)
    |> Enum.sum()
  end

  def extract_first_and_last_digits(digits_str) do
    cleaned_digits_str = String.replace(digits_str, ~r/\D/, "")
    first_digit = cleaned_digits_str |> String.at(0)
    last_digit = cleaned_digits_str |> String.at(-1)
    String.to_integer(first_digit <> last_digit)
  end

  @digit_by_words %{
    one: 1,
    two: 2,
    three: 3,
    four: 4,
    five: 5,
    six: 6,
    seven: 7,
    eight: 8,
    nine: 9
  }

  @forward_word_regex @digit_by_words
                      |> Map.keys()
                      |> Enum.map(&Atom.to_string/1)
                      |> (&["\\d" | &1]).()
                      |> Enum.join("|")
                      |> Regex.compile!()

  @backward_word_regex @digit_by_words
                       |> Map.keys()
                       |> Enum.map(&Atom.to_string/1)
                       |> Enum.map(&String.reverse/1)
                       |> (&["\\d" | &1]).()
                       |> Enum.join("|")
                       |> Regex.compile!()

  def regexes() do
    {@forward_word_regex, @backward_word_regex}
  end

  def solve_digits_and_words(file_path \\ nil) do
    input =
      if file_path == nil do
        """
        two1nine
        eightwothree
        abcone2threexyz
        xtwone3four
        4nineeightseven2
        zoneight234
        7pqrstsixteen
        """
      else
        File.read!(file_path)
      end

    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&extract_first_and_last_digits_or_words/1)
    |> Enum.sum()
  end

  def extract_first_and_last_digits_or_words(digits_str) do
    first_digit =
      @forward_word_regex |> Regex.run(digits_str) |> List.first() |> parse_word()

    last_digit =
      @backward_word_regex
      |> Regex.run(String.reverse(digits_str))
      |> List.first()
      |> String.reverse()
      |> parse_word()

    String.to_integer(first_digit <> last_digit)
  end

  def parse_word(word) do
    if Regex.match?(~r/^\d$/, word) do
      word
    else
      word
      |> String.to_existing_atom()
      |> (&Map.get(@digit_by_words, &1)).()
      |> Integer.to_string()
    end
  end
end
