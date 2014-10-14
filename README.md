Anubis
======

[![Package](http://img.shields.io/hexpm/v/anubis.svg)](https://hex.pm/packages/anubis)

Anubis is a library for creating command line applications in Elixir.

## Features

### Simple command creation

Anubis allows you to create command line applications with multiple commands (like [git](http://git-scm.com/)), without needing to define multiple mix tasks. This can be useful when exporting your command line application as an escript.

As you can see in the example, just call the `command` macro, passing in an atom for the command name, a description of that command, and the function that should be invoked when that command is run. Some restrictions apply to these functions. Firstly, it must be a named function. Also, the command should accept 1 parameter: the list of arguments after the command. In our example below, if we call

    $ mix example init some params

then the `Named.Function.init` function will be invoked with the arguments `["some", "params"]`.

### Simple option definition

Like most command line applications, yours may need to be configurable. This may include things like which credentials to use when connecting to another resource, or which file to load from disk.

Anubis makes defining which switches are valid and what their types are quite simple, as you can see in the example file below. Valid types include:

* :string
* :integer
* :boolean
* :float

*Be warned*: Anubis uses strict parsing, so any options that are passed in that haven't been defined will be ignored, and potentially have their value consumed as an argument.

Next release will include warnings when this occurs.

### Help out of the box

Once you've defined your commands, Anubis will automatically generate a help command for you, which lists out the available commands and their descriptions, along with what switches are available.

    $ mix example help

Your help can include a banner, describing the application and it's use. Use the `banner` macro (as in the example below) to set it up.

## An example

    defmodule Mix.Tasks.Example
      use Mix.Task
      use Anubis

      banner """
      This is the example task.

      Use it like:
          $ mix example <command> <args>
      """

      option :file,  :string,   "The file to be loaded."
      option :procs: :integer,  "The number of concurrent processes to run" 

      command :init, "Initialize the project.", Named.Function.init
      command :send, "Send me a small letter.", Named.Function.send
      command :list, "List all of the things.", Named.Function.list

      parse
    end
