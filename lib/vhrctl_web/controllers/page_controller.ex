defmodule VhrCtlWeb.PageController do
  use VhrCtlWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
