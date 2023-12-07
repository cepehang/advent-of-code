defmodule Aoc2023.Day3Test do
  use ExUnit.Case
  import Aoc2023.Day3

  test "parts numbers detection" do
    parts_numbers = example_engine_schematic() |> String.split("\n") |> find_parts_numbers()
    assert Enum.member?(parts_numbers, 467)
    assert Enum.member?(parts_numbers, 35)
    assert Enum.member?(parts_numbers, 633)
    assert Enum.member?(parts_numbers, 617)
    assert Enum.member?(parts_numbers, 592)
    assert Enum.member?(parts_numbers, 755)
    assert Enum.member?(parts_numbers, 664)
    assert Enum.member?(parts_numbers, 598)
  end

  test "parts numbers ignore" do
    parts_numbers = example_engine_schematic() |> String.split("\n") |> find_parts_numbers()
    assert not Enum.member?(parts_numbers, 114)
    assert not Enum.member?(parts_numbers, 58)
  end

  test "parts numbers sum" do
    assert solve_parts_numbers() == 4361
    assert solve_parts_numbers("test/fixtures/day3.txt") == 535_351
  end

  test "gear ratios detection" do
    gear_ratios = example_engine_schematic() |> String.split("\n") |> find_gear_ratios()
    assert Enum.member?(gear_ratios, 16345)
    assert Enum.member?(gear_ratios, 451_490)
  end

  test "gear ratios sum" do
    assert solve_gear_ratios() == 467_835
    assert solve_gear_ratios("test/fixtures/day3.txt") == 87_287_096
  end
end
