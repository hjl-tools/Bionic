#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <sys/stat.h>
#include <sys/statfs.h>

static void
hello ()
{
  printf ("sizeof time_t: %d\n", sizeof (time_t));
  printf ("sizeof off_t: %d\n", sizeof (off_t));
  printf ("sizeof struct stat: %d\n", sizeof (struct stat));
  printf ("sizeof struct statfs: %d\n", sizeof (struct statfs));
}

int
main ()
{
  atexit (hello);
  return 0;
}
