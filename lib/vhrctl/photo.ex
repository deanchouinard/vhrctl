defmodule VhrCtl.Photo do
@moduledoc """
Functions that work with photos from the robot.
"""
  @doc """
  Creates a list of photos sent by the robot.
  """
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

    acc <> "<tr><td>" <> readable_date(item) <> "</td><td>" <> "<img src='images/#{item}' alt='Girl in a jacket' width='200' height='200'>" <> "</td></tr>"
    # [[item, "images/#{item}"] | acc]
  end

  @doc "Converts filename to readable date"
  def readable_date(filename) do
    year = String.slice(filename, 0..3)
    month = String.slice(filename, 5..6)
    day = String.slice(filename, 8..9)
    hour = String.slice(filename, 10..11)
    minutes = String.slice(filename, 12..13)
    year <> "-" <> month <> "-" <> day <> " " <> hour <> ":" <> minutes
  end
end
