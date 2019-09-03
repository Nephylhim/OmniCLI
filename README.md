# OmniCLI

_One cli to rule them all._

Create small CLIs for your shell quickly and expand them at will.

___

I do love aliases, but they can be limited sometimes. CLIs solve the problem but it can takes some time to create them.

OmniCLI is developped to mitigate this issue. It allow to create *simple* CLIs quickly.

/!\ This tool is still in development. Some concept might change a little if necessary. Some features are also missing.

## Usage

Add a CLI command:

```bash
omnicli -a example hello 'echo "Hello $1!"' 'This command welcome you!'

# Command hello is created!
#
# Available commands for example:
#     hello  This command welcome you!
```

Register your new CLI:

```bash
omnicli -r
```

Use it:

```bash
example hello $USER

# Hello bob!
```

(my name isn't Bob ;) )

## TODO

* Complete description
* Advanced usages
* Installation
* Examples with complete CLIs.

## Contributing

Some automatics tests are executed to avoid breaking OmniCLI with a stupid change. These tests use [bats](https://github.com/sstephenson/bats).

```bash
make test
```

I personnaly use [reflex](https://github.com/cespare/reflex) as watcher to relaunch my tests when I modify the code. It can also be used to automatically test a command when you're developping it.

```bash
make watch
```

Please use [shellcheck](https://github.com/koalaman/shellcheck) to verify the code.

A debug helper is available: `test/debug.sh`.

TODO: complete

## Roadmap

* [x] MVP
	* [x] Execute commands through omnicli
	* [x] Add and remove commands/CLIs
	* [x] Listing clis and commands
	* [x] Use external config file
* [ ] Write OmniCLI help!
* [ ] Register CLIs as aliases
	* [x] base register
	* [ ] register only wanted CLIs
* [ ] Update commands
* [x] Use parameters in commands
* [ ] Nested commands
* [ ] Autocompletion
* [ ] Reorder commands for listing
* [ ] Commands shortcuts/aliases?
* [ ] Importing / exporting CLIs
* [ ] Improve debug mode
