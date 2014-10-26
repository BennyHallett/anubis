defmodule Anubis do

  defmacro banner(banner) do
    quote do
      @banner unquote(banner)
    end
  end

  defmacro command(name, description \\ "", f) do
    quote do
      @commands @commands ++ [{ unquote(to_string name), unquote(description) }]
      def _command([unquote(to_string name)|args], opts), do: {args, opts} |> unquote(f)
    end
  end

  defmacro option(name, type \\ :string, description \\ "") do
    quote do
      @options Dict.put(@options, unquote(name), { unquote(type), unquote(description) })
      @opt_dict Dict.put(@opt_dict, unquote(name), unquote(type))
    end
  end

  defmacro rc_file(dict) do
    quote do
      def init_rc, do: _init_rc(unquote(dict), Anubis.RcFile.exist?(__MODULE__))

      def _init_rc(_, true), do: nil
      def _init_rc(d, _), do: Anubis.RcFile.touch(d, __MODULE__)

      def _command(["initrc"|_], _), do: init_rc
    end
  end

  defmacro parse do
    quote do
      def _command(["help"|_], _), do: help

      def _command(_, _) do
        IO.puts "Command unknown."
        help
      end

      def help do
        IO.puts "#{@banner}\n"

        IO.puts "OPTIONS:\n"

        @options
        |> Dict.keys
        |> Enum.map(&("  --#{to_string &1} [#{Dict.get(@options, &1) |> elem(0) |> to_string}] - #{Dict.get(@options, &1) |> elem(1) |> to_string}"))
        |> Enum.join("\n")
        |> IO.puts

        IO.puts "\nCOMMANDS:\n"

        @commands
        |> Enum.map(&("  #{elem(&1, 0)} - #{elem(&1, 1)}"))
        |> Enum.join("\n")
        |> IO.puts
      end

      def run(args) do
        opts = OptionParser.parse(args, strict: @opt_dict)
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
      @opt_dict []
    end
  end

end
