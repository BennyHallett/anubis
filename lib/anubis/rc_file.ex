defmodule Anubis.RcFile do
  @moduledoc """
  Module that handles everything that has to do with the
  "runtime configuration" file and it's contents.
  """

  def exist?(module), do: module |> filename |> File.exists?

  def touch(map, module) do
    map
    |> Map.keys
    |> Enum.map(&("#{to_string(&1)}: #{Map.get(map, &1)}"))
    |> Enum.join("\n")
    |> _write(module)
  end

  defp _write(content, module), do: module |> filename |> File.write(content)

  def load(module), do: _load(exist?(module), module)

  defp _load(false, _), do: %{}
  defp _load(_, module) do
    module
    |> filename
    |> File.read!
    |> String.split("\n")
    |> parse
  end

  defp parse(lines), do: _parse(lines, %{})

  defp _parse([], map), do: map
  defp _parse([pair | tail], map) do 
    [key, value] = pair |> String.split(": ")
    _parse(tail, Map.put(map, String.to_atom(key), parse_value(value)))
  end

  defp parse_value("false"), do: false
  defp parse_value("true"), do: true
  defp parse_value(number), do: parse_number(number)

  defp parse_number(number), do: _parse_number(Integer.parse(number), number)
  defp _parse_number(:error, num), do: num
  defp _parse_number({num, ""}, _), do: num
  defp _parse_number({_, _}, num) do
    {value, _} = Float.parse(num)
    value
  end

  def filename(module) do
    module
    |> to_string
    |> String.downcase
    |> String.split(".")
    |> _filename
    |> _path
  end
  
  defp _filename(["elixir", "mix", "tasks" | filename]), do: ".#{filename |> Enum.join("_")}.rc"
  defp _filename(["elixir" | list]), do: ".#{list |> Enum.join("_")}.rc"

  defp _path(filename), do: Path.join("~", filename) |> Path.expand
end
