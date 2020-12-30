defmodule VhrCtlWeb.ApiController do
  use VhrCtlWeb, :controller

  def env(conn, params) do
    IO.inspect conn, label: "CONN"
    IO.inspect params, label: "PARAMS"
    json(conn, %{id: "from /api/env"})
#    render(conn, "env.html")
  end
  
end

