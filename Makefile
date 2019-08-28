.PHONY: all test watch

all:

test:
	# clear;
	cd test;\
	bats tests.bats

watch:
	reflex -d none -s -r '.sh|.bats' -- bash -c "clear; make test"
