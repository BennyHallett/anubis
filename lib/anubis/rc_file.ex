defmodule Anubis.RcFile do

  def exist?(module), do: module |> filename |> File.exists?

  def touch(dict, module) do
    dict
    |> Dict.keys
    |> Enum.map(&("#{to_string(&1)}: #{Dict.get(dict, &1)}"))
    |> Enum.join("\n")
    |> _write(module)
  end

  defp _write(content, module), do: module |> filename |> File.write(content)

  def load do
    nil
  end

  def filename(module) do
    module
    |> to_string
    |> String.downcase
    |> String.split(".")
    |> _filename
    |> _path
  end
  
  defp _filename(["elixir", "mix", "tasks"|filename]), do: ".#{filename |> Enum.join("_")}.rc"
  defp _filename(["elixir" | list]), do: ".#{list |> Enum.join("_")}.rc"

  defp _path(filename), do: Path.join("~", filename) |> Path.expand

end
