#/* GCC+Coverage demo.
# *
# * Copyright 2012 (C) Assaf Gordon
# * License: AGPLv3+
# *
# * See README.md file for details.
# */
PMCCABE := $(shell which pmccabe)

CFLAGS=-O0 -Wall -Wextra -g -fprofile-arcs -ftest-coverage -std=c99
CC=gcc
LDFLAGS=-lm

all: conv

conv: conv.c

clean_cov:
	@rm -f conv.gcda

clean:
	@rm -rf conv conv.gcda conv.gcno *.lcov lcov-html

## run some tests
testlow: run_tests.sh conv clean_cov
	./run_tests.sh low

testhigh: run_tests.sh conv clean_cov
	./run_tests.sh high

testmax: run_tests.sh conv clean_cov
	./run_tests.sh max

conv.gcda:
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
cov: conv conv.gcda
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

have_pmccabe:
ifeq ($(PMCCABE),)
	$(error The program 'pmccabe' is not installed)
endif

mccabe: have_pmccabe conv.c
	@pmccabe -v -c conv.c

mccabe10: have_pmccabe conv.c
	@echo ""
	@echo "The following functions have McCabe complexity>=10"
	@echo ""
	@echo "Cmplx	File(line): Function"
	@( pmccabe -c conv.c | awk '$$1>=10' | cut -f1,6- )
	@echo "-End Of List-"
	@echo ""

toolong: have_pmccabe conv.c
	@echo ""
	@echo "The following functions are longer than 35 lines."
	@echo ""
	@echo "Lines	File(line): Function"
	@( pmccabe -c conv.c | awk '$$5>35' | cut -f5- )
	@echo "-End Of List-"
	@echo ""
