defmodule Anubis do
  @moduledoc """
  Anubis is a library for creating command line applications in Elixir.

  Some of the features of Anubis include:
    - Simple command creation
    - Simple option definition
    - Help out of the box
    - Runtime configuration

  ### Examples:

    ```elixir
    defmodule AnubisExample do
      use Anubis

      banner "This is an example application using Anubis."

      rc_file %{
        username: "user",
        password: "p4$$w0rd",
        people: 10
      }

      option "verbose", :boolean, "Whether or not to be verbose with the output."

      command :fetch, "Fetch something from the internet", AnubisExample.Function.fetch
    end
    ```
  """

  @doc """
  Sets the banner as the description for the cli application.
  """
  @spec banner(banner :: String.t) :: no_return
  defmacro banner(banner) do
    quote do
      @banner unquote(banner)
    end
  end

  @doc """
  Declares a command for the cli application.
  The function is restricted by the following:
    - Firstly, it must be a named function.
    - Also, it should accept 1 parameter: the list of arguments after the command.

  ## Examples

    $ mix example init some params
  """
  @spec command(name :: String.t, description :: String.t, fun :: fun()) :: no_return
  defmacro command(name, description \\ "", fun) do
    quote do
      @commands @commands ++ [{ unquote(to_string name), unquote(description) }]

      def _command([unquote(to_string name) | args], opts) do
        rc = Anubis.RcFile.load(__MODULE__)
        {args, opts, rc} |> unquote(fun)
      end
    end
  end

  @doc """
  Declares an option for the cli application.

  Anubis makes defining which switches are valid and what their types are quite simple, as you can see in the example file below. Valid types include:

    - :string
    - :integer
    - :boolean
    - :float

  Be warned: Anubis uses strict parsing, so any options that are passed in that haven't been defined will be ignored,
  and potentially have their value consumed as an argument (next release will include warnings when this occurs).
  """
  @spec option(name :: String.t, type :: atom(), description :: String.t) :: no_return
  defmacro option(name, type \\ :string, description \\ "") do
    quote do
      @options Keyword.put(@options, unquote(name), { unquote(type), unquote(description) })
      @opt_list Keyword.put(@opt_list, unquote(name), unquote(type))
    end
  end

  @doc """
  Declares the runtime configuration command inside the current application.
  """
  @spec rc_file(map :: map()) :: no_return
  defmacro rc_file(map) do
    quote do
      @commands @commands ++ [{ "initrc", "Initialize the runtime configuration file." }]

      def init_rc, do: _init_rc(unquote(map), Anubis.RcFile.exist?(__MODULE__))

      def _init_rc(_, true), do: nil
      def _init_rc(m, _), do: Anubis.RcFile.touch(m, __MODULE__)

      def _command(["initrc" | _], _), do: init_rc()
    end
  end

  @doc """
  Prepares every command as a function so it can be pattern
  match later on when parsing the command line arguments.

  It also declares the `help` command based on the options and commands
  previously decalared.
  """
  @spec parse() :: no_return
  defmacro parse do
    quote do
      @commands @commands ++ [{ "help", "View this help information." }]

      def _command(["help" | _], _), do: help()

      def _command(_, _) do
        IO.puts "Command unknown."
        help()
      end

      def help do
        IO.puts "#{@banner}\n"

        IO.puts "OPTIONS:\n"

        @options
        |> Map.keys
        |> Enum.map(fn key ->
          opt = Map.get(@options, key)
          "  --#{to_string key} [#{opt |> elem(0) |> to_string}] - #{opt |> elem(1) |> to_string}"
        end)
        |> Enum.join("\n")
        |> IO.puts

        IO.puts "\nCOMMANDS:\n"

        @commands
        |> Enum.map(&("  #{elem(&1, 0)} - #{elem(&1, 1)}"))
        |> Enum.join("\n")
        |> IO.puts
      end

      def run(args) do
        opts = OptionParser.parse(args, strict: @opt_list)
        _command(elem(opts, 1), elem(opts, 0))
      end
    end
  end

  defmacro __using__(_opts) do
    quote do
      import unquote(__MODULE__)

      @banner   ""
      @commands []
      @options  []
      @opt_list []
    end
  end
end
