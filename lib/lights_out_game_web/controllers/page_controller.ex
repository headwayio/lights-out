defmodule LightsOutGameWeb.PageController do
  use LightsOutGameWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
