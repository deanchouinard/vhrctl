defmodule VhrCtlWeb.UiController do
  use VhrCtlWeb, :controller
  
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
    IO.inspect c, label: "COL"
    IO.inspect v, label: "VAL"
    IO.inspect response, label: "RESPONSE"
    render(conn, "index.html", messenger: "#{List.to_string(v)}")
  end

end

