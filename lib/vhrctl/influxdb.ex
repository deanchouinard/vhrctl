defmodule VhrCtl.InfluxDB do

  @influxdb_url "http://localhost:8086/"

  def insert(temp, humid) do

    data = 'env,location=unit43,sensor=test temp=#{temp},humid=#{humid}'

    # :httpc.request(:post, {'http://localhost:8086/write?db=mydb', [], 'application/binary', data}, [], [])
    IO.inspect :httpc.request(:post, {'#{@influxdb_url}write?db=mydb', [], 'application/binary', data}, [], []), label: "INFLUXDB"

  end


end
