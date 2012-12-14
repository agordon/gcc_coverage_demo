/* GCC+Coverage demo.
 *
 * Copyright 2012 (C) Assaf Gordon
 * License: AGPLv3+
 *
 * See README.md file for details.
 */
#include <stdlib.h>
#include <stdio.h>
#include <err.h>
#include <errno.h>
#include <getopt.h>
#include <limits.h>

enum conv_type
{
	USE_NONE,
	USE_DOUBLE,
	USE_LONG
};

long double safe_string_to_double(const char* str)
{
	char *endptr;
	long double d;

	errno = 0;    /* To distinguish success/failure after call */
	d = strtod(str, &endptr);

	/* Coverage note: This 2-line "if" statement has multiple conditions
	 * (=branches). Not all of them can be ever tested in this situation.
	 * For example:
	 *  It is unclear if a "libc" implementation of "strtod"
	 *  returns errors other than ERANGE.
	 *  This error checking code is based on the linux man-page
	 *  if stdtod(3) - we keep it here for completeness,
	 *  but this will reduce the maximum possible coverage.
	 *  */
	if ((errno == ERANGE)
			|| (errno != 0 && d == 0))
		err(1,"strtod('%s') failed:", str);

	if (endptr == str)
		errx(1, "No digits were found in '%s'", str);

	if (*endptr != '\0')
	        errx(1, "Extra characters found: '%s'", endptr);

	return d;
}

long int safe_string_to_long(const char* str)
{
	char *endptr;
	long int val;

	errno = 0;    /* To distinguish success/failure after call */
	val = strtol(str, &endptr, 10);

	/* Check for various possible errors */
	fprintf(stderr,"errno=%d   val=%ld\n",errno,val);

	/* Coverage note: This 2-line "if" statement has multiple conditions
	 * (=branches). Not all of them can be ever tested in this situation.
	 * For example:
	 *  The only documented ERRNO other than ERANGE is EINVAL,
	 *  which happens only if 'base' is not 10 - will never happen in this
	 *  program. so either accept less than 100% (but keep the safest
	 *  error checking statement), or change the code.
	 *  */
	if ((errno == ERANGE && (val == LONG_MAX || val == LONG_MIN))
			|| (errno != 0 && val == 0))
		err(1,"strtol('%s') failed:", str);

	if (endptr == str)
		errx(1, "No digits were found in '%s'", str);

	if (*endptr != '\0')
	        errx(1, "Extra characters found: '%s'", endptr);

	return 0;
}

int main(int argc, char* argv[])
{
	enum conv_type ct = USE_NONE ;
	int c;

	while ( (c=getopt(argc,argv,"dl"))!= -1 )
	{
		switch(c)
		{
		case 'd':
			ct = USE_DOUBLE;
			break;

		case 'l':
			ct = USE_LONG;
			break;
		default:
			errx(1,"unknown command-line option '%c'",c);
			break;
		}
	}

	if (ct==USE_NONE)
		errx(1,"error: no type specified (-d/-l)");

	if (optind==argc)
		errx(1,"error: no values specified");

	for (int i=optind;i<argc;++i)
	{
		const char* str = argv[i];
		long double d;
		long int l;

		switch (ct)
		{
		case USE_DOUBLE:
			d = safe_string_to_double(str);
			printf("%Lf\n", d);
			break;

		case USE_LONG:
			l = safe_string_to_long(str);
			printf("%ld\n", l);
			break;

		case USE_NONE:
			/* Coverage note: this point will never be reached, and
			   never be covered (because USE_NONE is checked above).
			   But the 'case' is required to avoid GCC warnings. */
			abort();
		}
	}

	return 0;
}
