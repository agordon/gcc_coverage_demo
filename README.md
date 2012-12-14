GCC/Coverage example
====================

This tiny project demonstrage the use of GCC's coverage facility, and the `lcov`
coverage report program.

TL;DR
-----

    # Compile
    make
    # Test
    make testhigh
    # Generate coverage report
    make cov
    # View coverage report: ./lcov-html/index.html

Requirements
------------

- `make` - to make magic happen.
- `gcc`  - to compile the program.
- `lcov` - to generate coverage reports.


Project Files
-------------

- `conv.c` - a small C program, which converts string to int/doubles.
    The implementation is minimal, but contains some instructional elements.

- `run_tests.sh` - A shell script which simulates a unit-testing for the `conv`
    program.

- `makefile` - a Makefile to run the commands

- `README.md` - This file.



Usage
-----

1. Run `make` to compile the C program. The resulting `conv` executable is
compiled with special GCC flags to enable profiling/coverage. Every time it is
run, profiling/coverage information is added to files on disk (`conv.gc??`).

2. Run `conv` to collect coverage information.
    1. To run it manually: `./conv -l 32` .
    2. To run a "bad" tests suite, run `make testlow`.
       The tests will only cover few of the control path in the program,
       resulting in *low* coverage report.
    3. To run a "high" tests suite, run `make testhigh`.
       The tests will only cover most of the control path in the program,
       resulting in *high* coverage report.
    3. To run a a *good* tests suite, run `make testmax`.
       All the possible control paths in the program will be covered,
       resulting in *good* coverage report.
       **NOTE:** some control paths in the program can not be tested at all.
       See source code for details.

3. Run `make cov` to generate the coverage report. The HTML report is stored in `./lcov-html/index.html`

Technical Details
-----------------

- **Compilation Flags** - see `CFLAGS` in `Makefile` .
    Also see [GCC Debugging Options](http://gcc.gnu.org/onlinedocs/gcc/Debugging-Options.html#index-fprofile_002darcs-577) .

- **LCOV Usage** - see `cov:` target in `Makefile` .

- `conv.gcno` and `conv.gcda` - The generated coverage data files, see details
    at the [gcov website](http://gcc.gnu.org/onlinedocs/gcc/Gcov-Data-Files.html#Gcov-Data-Files).


Contact
-------

Assaf Gordon ( assafgordon at gmail dot com )


License
-------

AGPLv3+

