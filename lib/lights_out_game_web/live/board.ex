defmodule LightsOutGameWeb.Board do
  use LightsOutGameWeb, :live_view
  import LightsOutGameWeb.Games

  def mount(_params, _session, socket) do
    {:ok, assign(socket, grid: %{}, win: false)}
  end

  def handle_params(params, _uri, socket) do
    grid = reset_grid()

    case params["game_id"] do
      game when not is_nil(game) ->
        game_id = String.to_integer(game)
        {:noreply, assign(socket, game: game_id, grid: load_game(grid, game_id), win: false)}

      _ ->
        {:noreply, push_patch(socket, to: "/1")}
    end
  end

  def handle_event("toggle", %{"x" => strX, "y" => strY}, socket) do
    grid = socket.assigns.grid
    grid_x = String.to_integer(strX)
    grid_y = String.to_integer(strY)

    updated_grid =
      find_adjacent_tiles(grid_x, grid_y)
      |> Enum.reduce(%{}, fn point, acc ->
        Map.put(acc, point, !grid[point])
      end)
      |> then(fn toggled_grid -> Map.merge(grid, toggled_grid) end)

    win = check_win(updated_grid)

    socket = assign(socket, grid: updated_grid, win: win)

    case win do
      true -> {:noreply, push_event(socket, "gameover", %{win: win})}
      _ -> {:noreply, socket}
    end
  end

  defp find_adjacent_tiles(x, y) do
    prevX = Kernel.max(0, x - 1)
    nextX = Kernel.min(4, x + 1)
    prevY = Kernel.max(0, y - 1)
    nextY = Kernel.min(4, y + 1)

    [{x, y}, {prevX, y}, {nextX, y}, {x, prevY}, {x, nextY}]
  end

  def next_game(game) do
    count_games()
    |> Kernel.min(game + 1)
  end

  def prev_game(game), do: Kernel.max(1, game - 1)

  def first_game?(game), do: game === 1

  def last_game?(game), do: game == count_games()

  defp count_games do
    games()
    |> Map.keys()
    |> length()
  end

  defp reset_grid do
    for x <- 0..4, y <- 0..4, into: %{}, do: {{x, y}, false}
  end

  defp load_game(grid, id) do
    games()
    |> Map.get(id, [])
    |> then(fn game -> setup_tiles(grid, game) end)
  end

  defp setup_tiles(grid, []), do: grid

  defp setup_tiles(grid, [{x, y} | rest]) do
    grid
    |> Map.put({x, y}, true)
    |> setup_tiles(rest)
  end

  defp check_win(grid) do
    grid
    |> Map.values()
    |> Enum.all?(&(!&1))
  end
end
