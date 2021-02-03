defmodule VhrCtlWeb.UiController do
  use VhrCtlWeb, :controller
  alias VhrCtlWeb.HTMLTable
  
  @influxdb_url   Application.get_env(:vhrctl, :influxdb_url)
  @robot_url   Application.get_env(:vhrctl, :robot_url)
  
  def index(conn, _params) do
    render(conn, "index.html", messenger: "")
  end
  
  def take_picture(conn, _params) do
    HTTPoison.start
    response = HTTPoison.get! "#{@robot_url}/api/env"
    IO.inspect response, label: "RESPONSE"
    render(conn, "index.html", messenger: "")
  end

  def ping(conn, _params) do
    %HTTPoison.Response{ body: response} =
      HTTPoison.get! "#{@robot_url}/api/ping"
    render(conn, "index.html", messenger: "#{response}")
  end

  def iflx(conn, _params) do
    %HTTPoison.Response{ body: response} =
      HTTPoison.get! '#{@influxdb_url}/query?db=mydb;q=select+*+from+env+order+by+desc+limit+20;'

    response = Poison.decode(response)
    #{:ok, "results" => [%{"series" => [%{"columns" => col}]}]} = response
    {:ok, %{"results" => [%{"series" => [%{"columns" => c, "values" => v}]}]}} = response

    columns = ["time","batt","humid", "temp"]

    t_str = "<table><thead>"
    t_header = Enum.reduce(columns, t_str, &(HTMLTable.header(&1, &2)))
    t_str = t_header <> "</thead><tbody>"

    tabl = Enum.reduce(v, t_str, &(HTMLTable.detail(&1,&2)))
    tabl = tabl <> "</tbody></table"

    IO.puts tabl
    IO.inspect c, label: "COL"
    IO.inspect v, label: "VAL"
    IO.inspect response, label: "RESPONSE"
    render(conn, "index.html", messenger: tabl)
  end

end

