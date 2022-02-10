defmodule VhrCtl.Sensor do
  @robot_url   Application.get_env(:vhrctl, :robot_url)

  def read_sensor() do
    %HTTPoison.Response{ body: response} =
      HTTPoison.get! "#{@robot_url}/api/read_sensor"
    IO.inspect response, label: "READ_SENSOR"

  end
end
