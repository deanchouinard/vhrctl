defmodule VhrCtl.Pushover do

  @pushover_keys Application.get_env(:vhrctl, VhrCtl.Pushover)
  # @app_key   Application.get_env(:pushover, :app_key)

  def test() do
    IO.puts(@pushover_keys[:key])
    IO.puts(@pushover_keys[:app_token])
  end

  def push_notification(msg) do

    url = "https://api.pushover.net/1/messages.json"
    body = "{\"token\" : \"#{@pushover_keys[:app_token]}\", \"user\" : \"#{@pushover_keys[:key]}\", \"message\" : \"#{msg}\"} "

     case HTTPoison.post(url, body, [{"Content-Type", "application/json"}]) do
       {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
         #build_table(response)
         IO.puts body
       {:ok, %HTTPoison.Response{status_code: 404}} ->
         "Not found :("
       {:error, %HTTPoison.Error{reason: reason}} ->
         IO.inspect reason
         "Error"
     end

  end
end
