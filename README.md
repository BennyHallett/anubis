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

The named function must accept a single tuple as a parameter. This tuple will have three entries, `{arguments, options, runtime_configuration}`.

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

### Runtime configuration in a snap

Some command line apps need more powerful configuration than just switches. Where switches can be used to control a single invocation of the application, maybe you want to configure your environment to run a certain way every time.

This is where the RC file comes in.

We define our runtime configuration by using the `rc_file` macro, which takes a single dictionary as its parameter. This specifies the default contents of the file, but once it's created we can modify it to include whatever we want.

> *NOTE:* Anubis doesn't support nested structures in the rc file. Each entry in the dictionary should be either a `String`, `Integer`, `Float`, or `Boolean`. Anubis will respect the types included in the dictionary, and will load them out the same way they were stored.

By using the `rc_file` macro, we get an extra command created for us: `initrc`. This command will write out an RC file to the current user's home directory, based on the module name given. It will strip off `Mix.Tasks`, so our rc file in the example below would be `~/.example.rc`

## An example

```elixir
defmodule Mix.Tasks.Example
  use Mix.Task
  use Anubis

  banner """
  This is the example task.

  Use it like:
      $ mix example <command> <args>
  """

  rc_file %{
    username: "user",
    password: "p4$$w0rd",
    people: 10
  }

  option :file,  :string,   "The file to be loaded."
  option :procs: :integer,  "The number of concurrent processes to run" 

  command :init, "Initialize the project.", Named.Function.init
  command :send, "Send me a small letter.", Named.Function.send
  command :list, "List all of the things.", Named.Function.list

  parse
end
```
