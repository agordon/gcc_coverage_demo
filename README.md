Coverage and Code-Complexity example
====================================

This tiny project demonstrage the use of GCC's coverage facility, and the `lcov`
coverage report program, and McCabe complexity of a C program.

TL;DR
-----

    # Compile
    make
    # Test
    make testhigh
    # Generate coverage report
    make cov
    # View coverage report: ./lcov-html/index.html

    # See McCabe complexity for each function
    make mccabe

    # List functions with McCabe complexity>=10
    make mccabe10

    # List functions longer than 35 lines
    make toolong


Requirements
------------

- `make` - to make magic happen.
- `gcc`  - to compile the program.
- `lcov` - to generate coverage reports.
- `pmccabe` - (optional) to compute McCabe complexity

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
    3. To run the *maximum* tests suite, run `make testmax`.
       All the possible control paths in the program will be covered,
       resulting in *good* coverage report.
       **NOTE:** some control paths in the program can not be tested at all.
       See source code for details.

3. Run `make cov` to generate the coverage report. The HTML report is stored in `./lcov-html/index.html`

4. Run `make mccabe` to compute McCabe complexity of each function in `conv.c`

        $ make mccabe
        Modified McCabe Cyclomatic Complexity
        |   Traditional McCabe Cyclomatic Complexity
        |       |    # Statements in function
        |       |        |   First line of function
        |       |        |       |   # uncommented nonblank lines in function
        |       |        |       |       |  filename(definition line number):function
        |       |        |       |       |           |
        2	6	6	24	12	conv.c(24): suffix_power
        10	10	24	37	30	conv.c(37): safe_string_to_double
        8	8	12	85	16	conv.c(85): safe_string_to_long
        7	12	29	117	48	conv.c(117): main

5. Run `make mccabe10` to list functions with McCabe complexity>=10.
   These functions are good candidates for refactoring.

        $ make mccabe10
        
        The following functions have McCabe complexity>=10
        
        Cmplx  File(line): Function
        10     conv.c(37): safe_string_to_double
        -End Of List-

6. Run 'make toolong' to list functions longer than 35 lines (non-comments,
   non-blank lines). These functions are good candidates for refactoring.

        $ make toolong
        
        The following functions are longer than 35 lines.
        
        Lines  File(line): Function
        48     conv.c(117): main
        -End Of List-



Technical Details
-----------------

- **Compilation Flags** - see `CFLAGS` in `Makefile` .
    Also see [GCC Debugging Options](http://gcc.gnu.org/onlinedocs/gcc/Debugging-Options.html#index-fprofile_002darcs-577) .

- **LCOV Usage** - see `cov:` target in `Makefile` and [The LCOV Homepage](http://ltp.sourceforge.net/coverage/lcov.php).

- `conv.gcno` and `conv.gcda` - The generated coverage data files, see details
    at the [gcov website](http://gcc.gnu.org/onlinedocs/gcc/Gcov-Data-Files.html#Gcov-Data-Files).

- **McCabe Complexity** - see [PMCCABE Home Page](http://www.parisc-linux.org/~bame/pmccabe/overview.html) and
  [Cyclomatic complexity (wikipedia)](http://en.wikipedia.org/wiki/Cyclomatic_complexity)


Contact
-------

Assaf Gordon ( assafgordon at gmail dot com )

Git Repository: [agordon/gcc_coverage_demo](https://github.com/agordon/gcc_coverage_demo) on GitHub.


License
-------

AGPLv3+

