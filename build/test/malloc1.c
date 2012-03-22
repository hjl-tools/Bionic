#include <stdio.h>
#include <stdlib.h>

#define ALIGN (2 * sizeof (void *) - 1)

void *
test (size_t s)
{
  void *p = malloc (s);

  printf ("malloc: %d, %p: %d\n", s, p, ((unsigned long) p) & ALIGN);
  return p;
}
int
main ()
{
  void *p;
  int ret = 0;
  
  p = test (2);
  ret |= (unsigned long) p & ALIGN;
  free (p);

  p = test (8);
  ret |= (unsigned long) p & ALIGN;
  free (p);

  p = test (13);
  ret |= (unsigned long) p & ALIGN;
  free (p);

  p = test (16);
  ret |= (unsigned long) p & ALIGN;
  free (p);

  p = test (23);
  ret |= (unsigned long) p & ALIGN;
  free (p);

  p = test (43);
  ret |= (unsigned long) p & ALIGN;
  free (p);

  p = test (123);
  ret |= (unsigned long) p & ALIGN;
  free (p);

  return ret;
}
