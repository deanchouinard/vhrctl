defmodule VhrCtl.InfluxDB do
@moduledoc """
Interface to InfluxDB.
"""
  alias VhrCtlWeb.HTMLTable
  #@influxdb_url "http://localhost:8086/"
  @influxdb_url   Application.get_env(:vhrctl, :influxdb_url)

  def read_table() do

    %HTTPoison.Response{ body: response} = HTTPoison.get! '#{@influxdb_url}/query?db=mydb;q=select+*+from+env+order+by+desc+limit+20;'

    response = Poison.decode(response)
    #{:ok, "results" => [%{"series" => [%{"columns" => col}]}]} = response
    IO.inspect response, label: "RESPONSE"
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

    tabl
  end
  def insert(temp, humid, batt) do

    data = 'env,location=unit43,sensor=test temp=#{temp},humid=#{humid},batt=#{batt}'

    # :httpc.request(:post, {'http://localhost:8086/write?db=mydb', [], 'application/binary', data}, [], [])
    IO.inspect :httpc.request(:post, {'#{@influxdb_url}write?db=mydb', [], 'application/binary', data}, [], []), label: "INFLUXDB"

  end


end
