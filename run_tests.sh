#!/bin/sh

##
## This script runs "conv" with multiple options,
## testing various code flows.
##
## NOTE:
##  This is not a real unit testing, because it doesn't test
##  the actual output of the program. it just runs the program
##  in various ways to generate coverage.
##  a real unit-testing will also check the output values and exit code.
##

TYPE=$1
if [ -z "$TYPE" ] ; then
	echo "Missing coverage type: 'low' / 'high' / 'max'" >&2
	exit 1
fi
if [ "$TYPE" != "high" -a "$TYPE" != "low" -a "$TYPE" != "max" ] ; then
	echo "Error: invalid coverage '$TYPE': expecting low/high/max" >&2
	exit 1
fi

PROG=./conv

[ -x "$PROG" ] || { echo "Error: can't find executable '$PROG'" >&2 ; exit 1 ; }

$PROG -d 43 > /dev/null 2>/dev/null
$PROG -d 12.4 > /dev/null 2>/dev/null
$PROG -l 546 > /dev/null 2>/dev/null

if [ "$TYPE" = "high" -o "$TYPE" = "max" ]; then
	# test many more cases, covering as many lines and branches as possible.

	# Test 'human' suffix
	$PROG -h '3K' > /dev/null 2>/dev/null
	$PROG -h '4.5T' > /dev/null 2>/dev/null
	$PROG -h '3Q' > /dev/null 2>/dev/null
	$PROG -h '3Gi' > /dev/null 2>/dev/null

	# trigger 'extra characters'
	$PROG -d "3K" > /dev/null 2>/dev/null
	$PROG -l "3K" > /dev/null 2>/dev/null

	# trigger 'ERAGE'
	$PROG -d "20e4000" > /dev/null 2>/dev/null
	$PROG -l "123456789012345678901234567890" > /dev/null 2>/dev/null

	# trigger 'no digits found'
	$PROG -d "" > /dev/null 2>/dev/null
	$PROG -l "" > /dev/null 2>/dev/null

	# trigger LONG_MIN ERAGE
	$PROG -l -- "-123456789012345678901234567890" > /dev/null 2>/dev/null

	# no long/double
	$PROG 32 > /dev/null 2>/dev/null
fi

if [ "$TYPE" = "max" ]; then
	# for maximum testing, test invalid combination and extreme cases

	# Invalid options
	$PROG -q > /dev/null 2>/dev/null

	# missing values
	$PROG -l > /dev/null 2>/dev/null

	# Test all human suffixes
	$PROG -h '9M' > /dev/null 2>/dev/null
	$PROG -h '1P' > /dev/null 2>/dev/null
	# Extra characters after 'human' suffix
	$PROG -h '3KK' > /dev/null 2>/dev/null

fi

exit 0
