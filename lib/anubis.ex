defmodule Anubis do

  defmacro banner(banner) do
    quote do
      @banner unquote(banner)
    end
  end

  defmacro command(name, description \\ "", f) do
    quote do
      @commands @commands ++ [{ unquote(to_string name), unquote(description) }]
      def _command([unquote(to_string name)|args]), do: args |> unquote(f)
    end
  end

  defmacro parse do
    quote do
      def _command(["help"|_]), do: help

      def _command(_) do
        IO.puts "Command unknown."
        help
      end

      def help do
        IO.puts "#{@banner}\n"

        IO.puts "Valid commands are:\n"

        @commands
        |> Enum.map(&("#{elem(&1, 0)} - #{elem(&1, 1)}"))
        |> Enum.join("\n")
        |> IO.puts
      end
    end
  end

  defmacro __using__(_opts) do
    quote do
      import unquote(__MODULE__)

      @commands []

      def run(args) do
        OptionParser.parse(args)
        |> elem(1)
        |> _command
      end
    end
  end

end
