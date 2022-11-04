defmodule LightsOutGameWeb.Board do
  use LightsOutGameWeb, :live_view

  def mount(_params, _session, socket) do
    grid = for x <- 0..4, y <- 0..4, into: %{}, do: {{x, y}, false}
    # %{{0, 0} => false, {0, 1} => false, ...}
    {:ok, assign(socket, grid: grid)}
  end
end
