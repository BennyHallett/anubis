defmodule La do
  def la({args, options}) do
    IO.puts "ARGS"
    args
    |> Enum.join(", ")
    |> IO.puts

    IO.puts "OPTS"
    options
    |> Enum.map(&("#{elem &1, 0} - #{elem &1, 1}"))
    |> Enum.join(", ")
    |> IO.puts
  end
end

defmodule Mix.Tasks.Example do
  use Mix.Task
  use Anubis

  banner "This is the banner"

#  rc_file %{
#    username: "user",
#    password: "pass"
#  }

  option :op, :integer, "This option does x"
  option :ha, :string, "Another"

  command :test, "Something", La.la

  parse
end
