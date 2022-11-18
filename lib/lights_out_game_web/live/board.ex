defmodule LightsOutGameWeb.Board do
  use LightsOutGameWeb, :live_view

  def mount(_params, _session, socket) do
    grid = for x <- 0..4, y <- 0..4, into: %{}, do: {{x, y}, false}
    {:ok, assign(socket, grid: grid)}
  end

  def handle_event("toggle", %{"x" => strX, "y" => strY}, socket) do
    grid = socket.assigns.grid
    grid_x = String.to_integer(strX)
    grid_y = String.to_integer(strY)

    updated_grid = Map.put(grid, {grid_x, grid_y}, !grid[{grid_x, grid_y}])

    {:noreply, assign(socket, :grid, updated_grid)}
  end
end
