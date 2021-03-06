/* UNIX-specific routines to get and set file attribute.
 *
 * These might be usable on other systems that have the following
 * identical things: fileno(), fstat(), chmod(), sys/types.h and
 * sys/stat.h.
 *
 * The contents of this file are hereby released to the public domain.
 *
 *                              -- Rahul Dhesi 2004/06/19
 */

#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>
#include <stdio.h>
#include "zooio.h"

/*
Get file attributes.  Currently only the lowest nine of the
**IX mode bits are used.  Also we return bit 23=0 and bit 22=1,
which means use portable attribute format, and use attribute
value instead of using default at extraction time.
*/

unsigned long getfattr(f)
ZOOFILE f;
{
	struct stat buf;		/* buffer to hold file information */
	int fd;

	fd = fileno(f);
	if (fstat(fd, &buf) == -1)
		return (NO_FATTR);      /* inaccessible -- no attributes */

	return (unsigned long)(buf.st_mode & 0x1ffL) | (1L << 22);
}

/*
Set file attributes.  Only the lowest nine bits are used.
*/

int setfattr(f, a)
char *f;				/* filename */
unsigned long a;			/* atributes to set */
{
	return chmod(f, (int) (a & 0x1ff));
}
