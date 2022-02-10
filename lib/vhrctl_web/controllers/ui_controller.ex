defmodule VhrCtlWeb.UiController do
  use VhrCtlWeb, :controller
  alias VhrCtl.Sensor

  #@influxdb_url   Application.get_env(:vhrctl, :influxdb_url)
  @robot_url   Application.get_env(:vhrctl, :robot_url)

  def index(conn, _params) do
    render(conn, "index.html", messenger: "")
  end

  def list_pictures(conn, _params) do
    photo_list = VhrCtl.Photo.photo_list()

    render(conn, "photo-list.html", messenger: photo_list)
  end

  def read_sensor(conn, _params) do
    response = Sensor.read_sensor()

    render(conn, "index.html", messenger: "#{response}")

  end


  def mv_rbt(conn, _params) do
    %HTTPoison.Response{ body: response} =
      HTTPoison.get! "#{@robot_url}/api/mv_rbt?cmd=f&val=2"
    IO.inspect response, label: "MV_RBT"
    render(conn, "index.html", messenger: "#{response}")
  end

  def move_rbt(conn, params) do
    #    body = "{\"date\" : \"#{vdate}\", \"ext_ip\" : \"#{external_ip}\",
    #  \"temp\" : #{temp}, \"humid\" : #{humid}, \"batt\" : #{batt}}"
    %{"ui" => %{ "direction" => dir, "mag" => mag} } = params
    body = "{\"dir\" : \"#{dir}\", \"mag\" : \"#{mag}\"}"
    url = "#{@robot_url}/api/move"
    {:ok, %HTTPoison.Response{body: response}} = HTTPoison.post url, body, [{"Content-Type", "application/jso     n"}]

    IO.inspect response, lable: "RESP"
    response = Poison.decode! response
    IO.inspect params, label: "MOVE_ROBOT_PARAMS"
    render(conn, "index.html", messenger: response["id"])

  end

  def take_picture(conn, _params) do
    HTTPoison.start
    response = HTTPoison.get! "#{@robot_url}/api/take_picture", [], recv_timeout: 200_000
    %HTTPoison.Response{body: body} = response
    IO.inspect(body, label: "BODY")
    _body = Poison.decode!(body)
    # %{"filename" => filename} = body
    #IO.inspect response, label: "RESPONSE"
    #IO.inspect body, label: "BODY"
    #:timer.sleep(1000)
    #render(conn, "photo.html", fphoto: "#{filename}")
    render(conn, "index.html", messenger: "take picture")
  end

  def ping(conn, _params) do
    %HTTPoison.Response{ body: response} =
      HTTPoison.get! "#{@robot_url}/api/ping"
    render(conn, "index.html", messenger: "#{response}")
  end

  def iflx(conn, _params) do
    tabl = VhrCtl.InfluxDB.read_table()
    render(conn, "index.html", messenger: tabl)
  end

  def photo(conn, params) do
    IO.puts "PAGE CONTROLLER PHOTO"
    # {:ok, body, conn} = Plug.Conn.read_part_body(conn, length: 8_000_000)
    {:ok, body, conn} = read_form(conn, <<127>> )
    # IO.inspect conn, label: "CONN"
    photo = conn.body_params["photo"]
    # IO.inspect photo, label: "PHOTO"
    id = conn.body_params["id"]
    # IO.inspect id, label: "ID"
    # IO.inspect params, label: "PARAMS"
    %{"photo" => photo} = params
    # IO.inspect photo, label: "PHOTO"
    %Plug.Upload{filename: filename} = photo
    # IO.inspect filename, label: "FILENAME"
    #IO.inspect params["photo"]
    # {:ok, file} = File.open "#{photo.path}", [:read]
    # {:ok, file} = File.open "test.png", [:write]
    # IO.binwrite file, body
    # File.close file
    IO.inspect(conn, label: "CONN")
    conn
    |> put_flash(:info, "A new photo has arrived.")
    File.copy!(photo.path, "priv/static/images/#{filename}")
    render(conn, "photo.html", fphoto: "images/#{filename}")
  end

  def read_form(conn, acc) do
    case Plug.Conn.read_part_body(conn, read_timeout: 8_000_000) do
      {:more, body, conn}
      -> IO.inspect body, label: "body-more"
        read_form(conn, << acc, body>> )
      {:ok, body, conn} ->
        IO.inspect body, label: "body-ok"
        read_form(conn, <<acc, body>>)
      {:done, conn} ->
        IO.inspect acc, label: "acc-done"
        {:ok, acc, conn}
    end
  end
end
