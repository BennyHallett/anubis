defmodule La do
  def la({args, options, rc}) do
    IO.puts "ARGS"
    args
    |> Enum.join(", ")
    |> IO.puts

    IO.puts "OPTS"
    options
    |> Enum.map(&("#{elem &1, 0} - #{elem &1, 1}"))
    |> Enum.join(", ")
    |> IO.puts

    IO.puts "RC"
    rc
    |> Map.keys
    |> Enum.map(&("#{to_string &1}: #{to_string Map.get(rc, &1)}"))
    |> Enum.join("\n")
    |> IO.puts
  end
end

defmodule Mix.Tasks.Example do
  use Mix.Task
  use Anubis

  banner "This is the banner"

  rc_file %{
    username: "user",
    password: "pass"
  }

  option :op, :integer, "This option does x"
  option :ha, :string, "Another"

  command :test, "Something", La.la

  parse()
end
