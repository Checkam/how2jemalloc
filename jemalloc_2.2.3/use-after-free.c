#include "include/jemalloc/jemalloc.h"
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

int main(int agrc, char **argv)
{
  printf("[+] Alloc buffer1 size of 8\n");
  char *buffer1 = malloc(sizeof(char) * 8);
  memset(buffer1, 'A', 7);
  printf("[%p] buffer1 : %s\n", buffer1, buffer1);

  printf("\n[+] Free buffer1\n");
  free(buffer1);

  printf("\n[+] Alloc buffer2 size of 8\n");
  char *buffer2 = malloc(sizeof(char) * 8);
  printf("[%p] buffer2 : %s\n", buffer2, buffer2);

  printf("\n[+] Modify buffer1 to B\n");
  memset(buffer1, 'B', 7);
  printf("[%p] buffer1 : %s\n", buffer1, buffer1);
  printf("[%p] buffer2 : %s\n", buffer2, buffer2);

  return EXIT_SUCCESS;
}
