defmodule Aoc2023.Day5 do
  @example """
  seeds: 82 1

  seed-to-soil map:
  50 98 2
  52 50 48

  soil-to-fertilizer map:
  0 15 37
  37 52 2
  39 0 15

  fertilizer-to-water map:
  49 53 8
  0 11 42
  42 0 7
  57 7 4

  water-to-light map:
  88 18 7
  18 25 70

  light-to-temperature map:
  45 77 23
  81 45 19
  68 64 13

  temperature-to-humidity map:
  0 69 1
  1 0 69

  humidity-to-location map:
  60 56 37
  56 93 4
  """

  def load_input(), do: @example |> String.trim()
  def load_input(nil), do: @example |> String.trim()
  def load_input(file_path), do: file_path |> File.read!() |> String.trim()

  def solve_map_conversions(file_path \\ nil) do
    input = load_input(file_path)

    {seeds, conversion_maps} = parse_input(input)

    conversion_maps |> Enum.reduce(seeds, &reduce_conversion_map_to_seeds(&1, &2)) |> Enum.min()
  end

  def parse_input(input) do
    [seeds_str, conversion_maps_str] = String.split(input, "\n\n", parts: 2)
    {parse_seeds(seeds_str), parse_conversion_maps(conversion_maps_str)}
  end

  def parse_seeds(str) do
    str
    |> String.split(": ")
    |> List.last()
    |> String.split(~r/\s+/)
    |> Enum.map(&String.to_integer/1)
  end

  def parse_conversion_maps(str) do
    str
    |> String.split("\n\n")
    |> Enum.map(&parse_conversion_map/1)
  end

  def parse_conversion_map(str) do
    str
    |> String.split("\n")
    |> Enum.drop(1)
    |> Enum.map(fn coordinates ->
      coordinates |> String.split(~r/\s+/) |> Enum.map(&String.to_integer/1)
    end)
    |> Enum.map(&List.to_tuple/1)
  end

  def reduce_conversion_map_to_seeds(conversion_map, seeds) do
    for seed <- seeds do
      conversion_rule =
        conversion_map
        |> Enum.find(fn {_, source_range_start, range_length} ->
          seed in source_range_start..(source_range_start + range_length - 1)
        end)

      case conversion_rule do
        nil ->
          seed

        {destination_range_start, source_range_start, _range_length} ->
          seed + destination_range_start - source_range_start
      end
    end
  end

  def solve_range_conversions(file_path \\ nil) do
    input = load_input(file_path)

    {seed_ranges, conversion_maps} = parse_range_input(input)

    conversion_maps
    |> Enum.reduce(seed_ranges, &reduce_conversion_map_to_seed_ranges(&1, &2))
    |> Enum.map(fn {seed, _} -> seed end)
    |> Enum.min()
  end

  def parse_range_input(input) do
    [seeds_str, conversion_maps_str] = String.split(input, "\n\n", parts: 2)
    {parse_seed_ranges(seeds_str), parse_conversion_maps(conversion_maps_str)}
  end

  def parse_seed_ranges(str) do
    str
    |> String.split(": ")
    |> List.last()
    |> String.split(~r/\s+/)
    |> Enum.map(&String.to_integer/1)
    |> Enum.chunk_every(2)
    |> Enum.map(&List.to_tuple/1)
  end

  def reduce_conversion_map_to_seed_ranges(conversion_map, seed_ranges) do
    seed_ranges
    |> Enum.flat_map(&next_seed_ranges(conversion_map, &1))
  end

  def next_seed_ranges(conversion_map, seed_range) do
    conversion_map
    |> Enum.reduce(
      {[], [seed_range]},
      fn conversion_rule, {shifted_ranges, not_yet_shifted_ranges} ->
        {current_shifted_ranges, current_unshifted_ranges} =
          not_yet_shifted_ranges
          |> Enum.map(fn range ->
            {shift_seed_range(conversion_rule, range),
             scan_unshifted_seed_range(conversion_rule, range)}
          end)
          |> Enum.reduce({[], []}, fn {cur_shifted_range, cur_unshifted_range},
                                      {acc_shifted_range, acc_unshifted_range} ->
            {cur_shifted_range ++ acc_shifted_range, cur_unshifted_range ++ acc_unshifted_range}
          end)

        {current_shifted_ranges ++ shifted_ranges, current_unshifted_ranges}
      end
    )
    |> (fn {shifted_ranges, unshifted_ranges} -> shifted_ranges ++ unshifted_ranges end).()
  end

  def shift_seed_range(
        {_dest_range_start, source_range_start, rule_length},
        {seed_range_start, seed_range_length}
      )
      when source_range_start + rule_length <= seed_range_start or
             source_range_start >= seed_range_start + seed_range_length do
    []
  end

  def shift_seed_range(
        {dest_range_start, source_range_start, _rule_length} = conversion_rule,
        {seed_range_start, _seed_range_length} = seed_range
      ) do
    shifted_seed_range =
      if source_range_start >= seed_range_start do
        dest_range_start
      else
        seed_range_start + dest_range_start - source_range_start
      end

    [
      {shifted_seed_range, range_intersection_length(conversion_rule, seed_range)}
    ]
  end

  def scan_unshifted_seed_range(
        {_dest_range_start, source_range_start, rule_length},
        {seed_range_start, seed_range_length} = seed_range
      )
      when source_range_start + rule_length <= seed_range_start or
             source_range_start >= seed_range_start + seed_range_length do
    [seed_range]
  end

  def scan_unshifted_seed_range(
        {_dest_range_start, source_range_start, rule_length} = conversion_rule,
        {seed_range_start, seed_range_length} = seed_range
      )
      when source_range_start + rule_length >= seed_range_start + seed_range_length do
    if source_range_start <= seed_range_start do
      []
    else
      [
        {seed_range_start,
         seed_range_length - range_intersection_length(conversion_rule, seed_range)}
      ]
    end
  end

  def scan_unshifted_seed_range(
        {_dest_range_start, source_range_start, rule_length} = conversion_rule,
        {seed_range_start, seed_range_length} = seed_range
      )
      when source_range_start + rule_length < seed_range_start + seed_range_length do
    intersection_length = range_intersection_length(conversion_rule, seed_range)

    if source_range_start <= seed_range_start do
      [
        {source_range_start + rule_length, seed_range_length - intersection_length}
      ]
    else
      [
        {seed_range_start, source_range_start - seed_range_start},
        {source_range_start + rule_length,
         seed_range_start + seed_range_length - source_range_start - rule_length}
      ]
    end
  end

  def range_intersection_length(
        {_dest_range_start, source_range_start, rule_length},
        {seed_range_start, seed_range_length}
      ) do
    Enum.min([
      source_range_start + rule_length - seed_range_start,
      seed_range_start + seed_range_length - source_range_start,
      seed_range_length,
      rule_length
    ])
  end
end
