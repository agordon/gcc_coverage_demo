#/* GCC+Coverage demo.
# *
# * Copyright 2012 (C) Assaf Gordon
# * License: AGPLv3+
# *
# * See README.md file for details.
# */

CFLAGS=-O0 -Wall -Wextra -g -fprofile-arcs -ftest-coverage -std=c99
CC=gcc
LDFLAGS=

all: conv

conv: conv.c

clean:
	@rm -rf conv conv.gcda conv.gcno *.lcov lcov-html

## run some tests
testlow: run_tests.sh conv
	./run_tests.sh low

testhigh: run_tests.sh conv
	./run_tests.sh high

testmax: run_tests.sh conv
	./run_tests.sh max

conv.gcno conv.gcda:
	@echo "Error: can't generate coverage report without running some tests first".
	@echo "Please run:"
	@echo "   make testlow"
	@echo " or"
	@echo "   make testhigh"
	@echo " or"
	@echo "   make testmax"
	@echo ""
	@echo "To generate coverage information"
	@exit 1

## generate coverage
cov: conv conv.gcno conv.gcda
	lcov --test-name conv_test --quiet \
		--directory `pwd` \
		--base-directory `pwd` \
		--output-file conv.lcov \
		--capture
	genhtml --prefix `pwd` \
		--title conv_test \
		--quiet \
		--output-directory lcov-html *.lcov
	@echo
	@echo "Coverage report:"
	@echo "   $(PWD)/lcov-html/index.html"
	@echo
