defmodule Aoc2023.Day10 do
  @transitions_by_tile %{
    ?| => %{up: :up, down: :down},
    ?- => %{left: :left, right: :right},
    ?L => %{down: :right, left: :up},
    ?J => %{down: :left, right: :up},
    ?7 => %{up: :left, right: :down},
    ?F => %{up: :right, left: :down}
  }

  def transitions_by_tile(), do: @transitions_by_tile

  @example """
  7-F7-
  .FJ|7
  SJLL7
  |F--J
  LJ.LJ
  """

  def load_input(nil), do: @example
  def load_input(file_path), do: File.read!(file_path)

  def solve_furthest_distance(file_path \\ nil) do
    map =
      file_path
      |> load_input()
      |> parse_input()

    starting_position = find_starting_position(map)
    starting_direction = starting_position |> find_starting_directions(map) |> List.first()

    loop_length = {starting_position, starting_direction} |> find_tile_loop(map) |> Enum.count()
    div(loop_length, 2)
  end

  def solve_enclosed_tiles(file_path \\ nil) do
    map =
      file_path
      |> load_input()
      |> parse_input()

    count_enclosed_tiles(map)
  end

  def parse_input(sketch) do
    sketch
    |> String.split("\n", trim: true)
    |> Enum.map(&to_charlist/1)
  end

  def count_enclosed_tiles(starting_map) do
    starting_position = find_starting_position(starting_map)
    starting_directions = find_starting_directions(starting_position, starting_map)

    tile_movement_loop =
      find_tile_loop({starting_position, List.first(starting_directions)}, starting_map)

    starting_tile = find_tile(starting_directions)
    complete_map = replace_tile(starting_map, starting_position, starting_tile)
    loop_intersection_map = compute_loop_intersection_map(complete_map, tile_movement_loop)

    loop_intersection_map
    |> Enum.map(fn loop_intersection_row ->
      loop_intersection_row |> Enum.filter(&(rem(&1, 2) == 1)) |> Enum.count()
    end)
    |> Enum.sum()
  end

  def find_starting_position(map) do
    {starting_row, starting_row_index} =
      map
      |> Enum.with_index()
      |> Enum.find(fn {row, _} -> row |> Enum.map(&(&1 == ?S)) |> Enum.any?() end)

    {?S, starting_column_index} =
      starting_row
      |> to_charlist()
      |> Enum.with_index()
      |> Enum.find(fn {char, _} -> char == ?S end)

    {starting_row_index, starting_column_index}
  end

  def find_starting_directions(starting_position, map) do
    [:left, :up, :right, :down]
    |> Enum.map(fn direction ->
      next_character = starting_position |> move_position(direction) |> get_character(map)

      can_reach_position =
        not is_nil(next_character) and next_character in Map.keys(@transitions_by_tile) and
          direction in Map.keys(@transitions_by_tile[next_character])

      if can_reach_position do
        direction
      else
        nil
      end
    end)
    |> Enum.filter(&(not is_nil(&1)))
  end

  def find_tile_loop({_position, _direction} = movement, map) do
    find_tile_loop(movement, map, [movement])
  end

  def find_tile_loop({_position, _direction} = movement, map, history) do
    next_movement = step(movement, map)
    {next_position, _} = next_movement
    next_character = get_character(next_position, map)

    if next_character in Map.keys(@transitions_by_tile) do
      find_tile_loop(next_movement, map, [next_movement | history])
    else
      history
    end
  end

  def step({current_position, direction}, map) when not is_nil(direction) do
    next_position = move_position(current_position, direction)
    next_character = get_character(next_position, map)

    next_direction =
      if next_character in Map.keys(@transitions_by_tile) do
        @transitions_by_tile |> Map.get(next_character) |> Map.get(direction)
      end

    {next_position, next_direction}
  end

  def move_position({row_index, column_index}, direction) do
    case direction do
      :right -> {row_index, column_index + 1}
      :left -> {row_index, column_index - 1}
      :up -> {row_index - 1, column_index}
      :down -> {row_index + 1, column_index}
    end
  end

  def get_character({row_index, column_index}, _map) when row_index < 0 or column_index < 0 do
    nil
  end

  def get_character({row_index, column_index}, map) do
    map |> Enum.at(row_index) |> Enum.at(column_index)
  end

  def find_tile(directions) do
    {tile, _} =
      Enum.find(@transitions_by_tile, fn {_, transitions} ->
        directions |> Enum.map(&(&1 in Map.values(transitions))) |> Enum.all?()
      end)

    tile
  end

  def replace_tile(map, {row_index, column_index}, tile) do
    List.update_at(map, row_index, fn tile_row ->
      List.update_at(tile_row, column_index, fn _ -> tile end)
    end)
  end

  def compute_loop_intersection_map(map, tile_movement_loop) do
    tile_loop_positions = Enum.map(tile_movement_loop, fn {position, _} -> position end)

    map
    |> Enum.with_index()
    |> Enum.map(fn {row, row_index} -> {Enum.with_index(row), row_index} end)
    |> Enum.map(fn {row_with_index, row_index} ->
      compute_loop_intersection_row(row_with_index, row_index, tile_loop_positions)
    end)
  end

  def compute_loop_intersection_row([], _, _) do
    []
  end

  def compute_loop_intersection_row(
        [{_, col_index} | rest_with_index],
        row_index,
        tile_loop_positions
      ) do
    intersection_count =
      if {row_index, col_index} in tile_loop_positions do
        0
      else
        count_right_loop_intersections(rest_with_index, row_index, tile_loop_positions)
      end

    [
      intersection_count
      | compute_loop_intersection_row(rest_with_index, row_index, tile_loop_positions)
    ]
  end

  def count_right_loop_intersections(rest_with_index, row_index, tile_loop_positions) do
    {intersection_count, _} =
      rest_with_index
      |> Enum.reduce(
        {0, nil},
        fn {tile, col_index}, {intersection_acc, last_loop_direction} ->
          if {row_index, col_index} in tile_loop_positions do
            case tile do
              ?- ->
                {intersection_acc, last_loop_direction}

              ?| ->
                {intersection_acc + 1, nil}

              turn_tile ->
                turn_directions = Map.values(@transitions_by_tile[turn_tile])
                current_loop_direction = Enum.find([:up, :down], &(&1 in turn_directions))

                case last_loop_direction do
                  nil ->
                    {intersection_acc + 1, current_loop_direction}

                  same_direction when same_direction == current_loop_direction ->
                    {intersection_acc + 1, nil}

                  _ ->
                    {intersection_acc, nil}
                end
            end
          else
            {intersection_acc, last_loop_direction}
          end
        end
      )

    intersection_count
  end
end
