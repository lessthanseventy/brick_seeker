defmodule BrickSeekerWeb.PageController do
  use BrickSeekerWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
