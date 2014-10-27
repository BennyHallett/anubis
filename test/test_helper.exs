ExUnit.start()

defmodule ExampleModule do

  def go({_args, _opts, _rc}) do
    true
  end

  def print({_args, _opts, rc}) do
    rc
  end

end

defmodule TestHelperTask do
  use Anubis

  banner """
  This is the test helper
  ======================
  """

  rc_file %{
    a: "A",
    b: false,
    c: 1,
    d: 2.3
  }

  option :a, :boolean, "This is an option"

  command :try, "Try to run this", ExampleModule.go
  command :print, "Print these", ExampleModule.print

  parse
end

defmodule TestHelper do

  def path, do: "~" |> Path.join(".testhelpertask.rc") |> Path.expand

  def cleanup do
    path
    |> File.rm
  end

  def datepart do 
    Chronos.today |> Chronos.Formatter.strftime("%Y-%0m-%0d")
  end

end
