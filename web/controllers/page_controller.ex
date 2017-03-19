defmodule JustCi.PageController do
  use JustCi.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
