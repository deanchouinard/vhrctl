defmodule VhrCtl.Photo do

  def photo_list() do
    file_list = File.ls!("priv/static/images/")
    file_list = Enum.sort(file_list, :desc)
    IO.inspect(file_list, label: "FILE LIST")

    file_list = Enum.reduce(file_list, "", &make_links(&1, &2))
    IO.inspect(file_list, label: "FILE LIST")

    table_header = "<table><thead><th>Name</th><th>link</th></thead><tbody>"

    table_header <> file_list <> "</tbody><table>"
  end

  def make_links(item, acc) do

    acc <> "<tr><td>" <> item <> "</td><td>" <> "<img src='images/#{item}' alt='Girl in a jacket' width='500' height='600'>" <> "</td></tr>"
    # [[item, "images/#{item}"] | acc]
  end
end
