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

* [x] MVP
	* [x] Execute commands through omnicli
	* [x] Add and remove commands/CLIs
	* [x] Listing clis and commands
	* [x] Use external config file
* [ ] Register CLIs as aliases
	* [x] base register
	* [ ] register only wanted CLIs
* [ ] Update commands
* [x] Use parameters in commands
* [ ] Nested commands
* [ ] Autocompletion
* [ ] Reorder commands for listing
* [ ] commands shortcuts/aliases?
* [ ] importing / exporting CLIs
