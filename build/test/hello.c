#include <stdio.h>
#include <stdlib.h>

static void
hello ()
{
  printf ("Hello world\n");
}

int
main ()
{
  atexit (hello);
  return 0;
}
