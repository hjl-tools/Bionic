#include <stdio.h>
#include <stdlib.h>

void *
test (size_t s)
{
  void *p = malloc (s);

  printf ("malloc: %d, %p: %d\n", s, p, ((unsigned long) p) & 0xf);
  return p;
}
int
main ()
{
  void *p;
  int ret = 0;
  
  p = test (2);
  ret |= (unsigned long) p & 0xf;
  free (p);

  p = test (8);
  ret |= (unsigned long) p & 0xf;
  free (p);

  p = test (13);
  ret |= (unsigned long) p & 0xf;
  free (p);

  p = test (16);
  ret |= (unsigned long) p & 0xf;
  free (p);

  p = test (23);
  ret |= (unsigned long) p & 0xf;
  free (p);

  p = test (43);
  ret |= (unsigned long) p & 0xf;
  free (p);

  p = test (123);
  ret |= (unsigned long) p & 0xf;
  free (p);

  return ret;
}
