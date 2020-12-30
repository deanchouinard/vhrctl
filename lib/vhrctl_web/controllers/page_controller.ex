defmodule VhrCtlWeb.PageController do
  use VhrCtlWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
  
  def hello(conn, %{"messenger" => messenger} = params) do
    render(conn, "hello.html", messenger: messenger)
  end
  
  # def photo(conn, %{"body" => body} = params) do
  #   render(conn, "hello.html", messenger: body)
  # end
  def photo(conn, params) do
    # {:ok, body, conn} = Plug.Conn.read_part_body(conn, length: 8_000_000)
    {:ok, body, conn} = read_form(conn, <<127>> )
    IO.inspect conn, label: "CONN"
    photo = conn.body_params["photo"]
    IO.inspect photo, label: "PHOTO"
    id = conn.body_params["id"]
    IO.inspect id, label: "ID"
    IO.inspect params, label: "PARAMS"
    # {:ok, file} = File.open "#{photo.path}", [:read]
    # {:ok, file} = File.open "test.png", [:write]
    # IO.binwrite file, body
    # File.close file
    File.copy(photo.path, "test.png")
    render(conn, "hello.html", messenger: "test photo")
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
