Coverage and Code-Complexity example
====================================

This tiny project demonstrage the use of several quality-control tools:

1. GCC's code coverage facility
2. The `lcov` coverage report program
3. McCabe complexity of a C program
4. llvm/clang static code analyzer

TL;DR
-----

    # Compile
    make
    # Test
    make testhigh
    # Generate coverage report
    make cov
    # View coverage report: ./lcov-html/index.html

    # Use CLANG static code analyzer to find errors
    make static-check

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
- `clang` - (optional) to use clang static code analyzer (tested with clang 3.3)
- `scan-build` - (optional) clang static code analyzer

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

7. Run `make static-check` to generate HTML report for bugs detected with clang's
   static code analyzer.

        $ make static-check
        /home/gordon/sources/llvm/checker-269/scan-build -o static \
                --use-cc=/usr/local/bin/clang \
                --use-analyzer=/usr/local/bin/clang \
                     /usr/local/bin/clang -o conv conv.c -lm
        scan-build: Using '/usr/local/bin/clang-3.3' for static analysis
        conv.c:44:2: warning: Value stored to 'd' is never read
                d = 42 ; /* this harmless but useless assignment should be detected
                ^   ~~
        1 warning generated.
        scan-build: 1 bugs found.
        scan-build: Run 'scan-view /home/gordon/projects/lcov_learn/static/2012-12-28-1' to examine bug reports.
        
        Check the above mention directory (in ./static/) for the bug report
        


Technical Details
-----------------

- **Compilation Flags** - see `CFLAGS` in `Makefile` .
    Also see [GCC Debugging Options](http://gcc.gnu.org/onlinedocs/gcc/Debugging-Options.html#index-fprofile_002darcs-577) .

- **LCOV Usage** - see `cov:` target in `Makefile` and [The LCOV Homepage](http://ltp.sourceforge.net/coverage/lcov.php).

- `conv.gcno` and `conv.gcda` - The generated coverage data files, see details
    at the [gcov website](http://gcc.gnu.org/onlinedocs/gcc/Gcov-Data-Files.html#Gcov-Data-Files).

- **McCabe Complexity** - see [PMCCABE Home Page](http://www.parisc-linux.org/~bame/pmccabe/overview.html) and
  [Cyclomatic complexity (wikipedia)](http://en.wikipedia.org/wiki/Cyclomatic_complexity)

- **llvm/clang** - Alternative compiler to GCC.
  See installation instructions below.

- **clang static code analyzer** - [](http://clang-analyzer.llvm.org/).
  See installation instructions below.


Installing LLVm/CLANG
---------------------

Not full instructions, just a quick reference. More information [here](http://www.llvm.org/docs/CMake.html)

** Installing building latest LLVM/CLANG **

Instead of using the official SVN repository, use the github mirror.

    # we'll call this <base> from now on
    $ mkdir /base/directory/of/llvm_src
    $ cd <base>

    # Get the base llvm tools
    $ git clone https://github.com/llvm-mirror/llvm.git

    # Add the clang tool
    $ cd <base>/llvm/tools
    $ git clone https://github.com/llvm-mirror/clang.git

    # Add the replacement Standard C++ library
    $ cd <base>/llvm/tools
    $ git clone https://github.com/llvm-mirror/libcxx.git

    # Add the compiler-rt project
    $ cd <base>/llvm/projects
    $ git clone https://github.com/llvm-mirror/compiler-rt.git

    # Add the test-suite
    $ cd <base>/llvm/projects
    $ git clone https://github.com/llvm-mirror/test-suite.git

    # **TODO**: how to add lldb?

    # Build llvm/clang
    $ cd <base>
    $ mkdir build
    $ cd build

    # Prepare out-of-tree build
    # more build options: http://www.llvm.org/docs/CMake.html#llvm-specific-variables
    $ cmake ../llvm -DLLVM_TARGETS_TO_BUILD=X86

    # Build
    $ make -j 4

    # Install
    $ sudo make install


**Installing CLANG static code analyzer**

Website: http://clang-analyzer.llvm.org/

Installation on Linux:

1. Install llvm+clang
2. Download latest static checker:

        $ wget http://bit.ly/USf8ge
        $ tar -xjvf Checker-269.tar.bz2

3. The checker is mostly perl/python scripts, so no need to install anything
4. The checker comes with a Mac-OSX clang binary, delete it:

        $ rm checker-269/bin/clang*

5. Ensure 'clang' is on your path:

        $ which clang
        /usr/local/bin/clang

6. Add Static Checker to the path

        $ export PATH=/home/gordon/sources/llvm/checker-269/:$PATH
        $ which scan-build
        /home/gordon/sources/llvm/checker-269/scan-build

To build an autotools project with scan-build, do the following

    $ scan-build -v -o check --use-cc=/usr/local/bin/clang --use-analyzer=/usr/local/bin/clang ./configure
    $ scan-build -v -o check --use-cc=/usr/local/bin/clang --use-analyzer=/usr/local/bin/clang make

The "check" directory should contain HTML bug reports.


Contact
-------

Assaf Gordon ( assafgordon at gmail dot com )

Git Repository: [agordon/gcc_coverage_demo](https://github.com/agordon/gcc_coverage_demo) on GitHub.


License
-------

AGPLv3+

