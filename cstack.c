#include <stdio.h>

int f2(int a)
{
  int z;
  
  printf("In F2, a is at %p\n", &a);
  printf("  And z is at %p\n", &z);
  return 0;
}

int f1(int a, int b)
{
  int y;
  
  printf("In function f1, b is at %p\n", &b);
  printf("In function f1, a is at %p\n", &a);
  printf("In function f1, y is at %p\n", &y);
  f2(y);
  return 0;
}

int main()
{
  int x;

  printf("X is at memory location %p\n", &x);
  f1(x, 100);
}

