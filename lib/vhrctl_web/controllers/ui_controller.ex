defmodule VhrCtlWeb.UiController do
  use VhrCtlWeb, :controller
  alias VhrCtlWeb.HTMLTable
  
  @influxdb_url   Application.get_env(:vhrctl, :influxdb_url)
  @robot_url   Application.get_env(:vhrctl, :robot_url)
  
  def index(conn, _params) do
    render(conn, "index.html", messenger: "")
  end

  def mv_rbt(conn, _params) do
    %HTTPoison.Response{ body: response} =
      HTTPoison.get! "#{@robot_url}/api/mv_rbt?cmd=f&val=2"
    IO.inspect response, label: "MV_RBT"
    render(conn, "index.html", messenger: "#{response}")
  end

    
  def take_picture(conn, _params) do
    HTTPoison.start
    response = HTTPoison.get! "#{@robot_url}/api/take_picture"
    %HTTPoison.Response{body: body} = response
    body = Poison.decode!(body)
    %{"filename" => filename} = body
    #IO.inspect response, label: "RESPONSE"
    #IO.inspect body, label: "BODY"
    :timer.sleep(1000)
    render(conn, "photo.html", fphoto: "#{filename}")
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

  def photo(conn, params) do
    IO.puts "PAGE CONTROLLER PHOTO"
    # {:ok, body, conn} = Plug.Conn.read_part_body(conn, length: 8_000_000)
    {:ok, body, conn} = read_form(conn, <<127>> )
    IO.inspect conn, label: "CONN"
    photo = conn.body_params["photo"]
    IO.inspect photo, label: "PHOTO"
    id = conn.body_params["id"]
    IO.inspect id, label: "ID"
    IO.inspect params, label: "PARAMS"
    %{"photo" => photo} = params
    IO.inspect photo, label: "PHOTO"
    %Plug.Upload{filename: filename} = photo
    IO.inspect filename, label: "FILENAME"
    #IO.inspect params["photo"]
    # {:ok, file} = File.open "#{photo.path}", [:read]
    # {:ok, file} = File.open "test.png", [:write]
    # IO.binwrite file, body
    # File.close file
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

