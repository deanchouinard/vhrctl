defmodule VhrCtlWeb.HTMLTable do

  def header(data, acc) do
    acc <> "<th>" <> data <> "</th>"
  end

  def detail(data, acc) do
    [dtime, batt, humid, _, _, temp] = data
    acc <> "<tr><td>" <> dtime <> "</td>" <> "<td>" <>
      Integer.to_string(batt) <> "</td>" <>
        "<td>" <> to_string(humid) <> "</td>" <>
          "<td>" <> to_string(temp) <> "</td></tr>"

      # :erlang.float_to_binary(humid, decimals: 2) <>
      #   :erlang.float_to_binary(temp, decimals: 2)
  end
end
