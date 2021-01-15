defmodule VhrCtlWeb.ApiController do
  use VhrCtlWeb, :controller
  alias VhrCtl.InfluxDB

  def env(conn, params) do
    IO.inspect conn, label: "CONN"
    IO.inspect params, label: "PARAMS"

    InfluxDB.insert(params["temp"], params["humid"], params["batt"])


    json(conn, %{id: "from /api/env"})
#    render(conn, "env.html")
  end
  
end

