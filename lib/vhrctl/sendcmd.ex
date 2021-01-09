defmodule VhrCtl.SendCmd do

  def send do
    #body ="{\"temp\" : #{temp}, \"humid\": #{humid}}"
    temp = 22
    data = "{'value' : #{temp}}"
    data = '{"value" : "hello"}'
    :httpc.request(:post, {'http://localhost:4500/api/env', [data], 'application/json', data}, [], [])

  end

end

