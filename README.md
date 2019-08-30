# OmniCLI

WIP - One cli to rule them all.

I do love aliases, but they can be limited sometimes. CLIs solve the problem but it can takes some time to create them.

OmniCLI is developped to mitigate this issue. It allow to create *simple* CLIs quickly.

TODO:

* Complete description
* Basic usages
* Advanced usages

## Tests

Tests use [bats](https://github.com/sstephenson/bats)

Watcher use [reflex](https://github.com/cespare/reflex)

Please use [shellcheck](https://github.com/koalaman/shellcheck) to verify code.

A debug helper is available: `test/debug.sh`. TODO: complete

## Roadmap

* MVP
	* Execute commands through omnicli
	* Add and remove commands/CLIs
	* Listing clis and commands
	* Use external config file
* Register CLIs as aliases
* Use parameters in commands
* Nested commands
* Autocompletion
