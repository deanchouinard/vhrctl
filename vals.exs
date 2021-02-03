defmodule Tabs do

  def ext(data, acc) do
    [a, _b, c] = data
    acc <> a <> c
  end

  def header(data, acc) do
    acc <> "<tr>" <> data <> "</tr>"
  end

  def mt(data, acc) do
    [dtime, batt, humid, _, _, temp] = data
    acc <> "<tr><td>" <> dtime <> "</td>" <> "<td>" <>
      Integer.to_string(batt) <> "</td>" <>
        "<td>" <> to_string(humid) <> "</td>" <>
          "<td>" <> to_string(temp) <> "</td></tr>"

      # :erlang.float_to_binary(humid, decimals: 2) <>
      #   :erlang.float_to_binary(temp, decimals: 2)
  end
end

vals = [["unit", 88, "er"],
  ["yiu",
    98, "ooh"]]
v = [["2021-01-30T00:03:27.463064532Z", 75, 25.43, "unit43", "test", 70.12],
  ["2021-01-30T00:02:37.519250239Z", 75, 25.43, "unit43", "test", 70.12],
  ["2021-01-30T00:01:47.532748336Z", 75, 25.38, "unit43", "test", 70.15],
  ["2021-01-30T00:00:57.451187216Z", 75, 25.34, "unit43", "test", 70.23],
  ["2021-01-30T00:00:07.905755794Z", 75, 25.38, "unit43", "test", 70.27],
  ["2021-01-29T23:58:30.558603926Z", 75, 25.31, "unit43", "test", 70.35],
  ["2021-01-29T23:40:24.941496091Z", 75, 25.01, "unit43", "test", 71.46],
  ["2021-01-29T23:39:35.019375351Z", 75, 25.02, "unit43", "test", 71.56],
  ["2021-01-29T23:38:44.986274876Z", 75, 24.99, "unit43", "test", 71.59],
  ["2021-01-29T23:37:54.985243036Z", 75, 25, "unit43", "test", 71.65],
  ["2021-01-29T23:37:09.373132614Z", 75, 24.99, "unit43", "test", 71.7],
  ["2021-01-29T22:44:50.598787011Z", 75, 24.85, "unit43", "test", 71.43],
  ["2021-01-29T22:44:00.614501338Z", 75, 24.7, "unit43", "test", 71.35],
  ["2021-01-29T22:43:11.184614391Z", 75, 24.83, "unit43", "test", 71.41],
  ["2021-01-29T22:41:20.965971253Z", 75, 24.81, "unit43", "test", 71.32],
  ["2021-01-29T20:37:08.032132252Z", 75, 25.22, "unit43", "test", 71.35],
  ["2021-01-29T20:36:18.050132235Z", 75, 25.13, "unit43", "test", 71.32],
  ["2021-01-29T20:35:29.171957943Z", 75, 25.1, "unit43", "test", 71.31],
  ["2021-01-29T20:34:38.018546507Z", 75, 25.08, "unit43", "test", 71.32],
  ["2021-01-29T20:33:47.949541486Z", 75, 24.93, "unit43", "test", 71.22]]

# columns = ["time","batt","humid","location","sensor","temp"]
columns = ["time","batt","humid", "temp"]

t_str = "<table><thead><tr>"
t_header = Enum.reduce(columns, t_str, &(Tabs.header(&1, &2)))
IO.puts t_header
t_str = t_header <> "</tr></thead><tbody>"

tab = Enum.reduce(vals, "", &(Tabs.ext(&1,&2)))
tabl = Enum.reduce(v, t_str, &(Tabs.mt(&1,&2)))
tabl = tabl <> "</tbody></table"

IO.puts tab
IO.puts tabl



