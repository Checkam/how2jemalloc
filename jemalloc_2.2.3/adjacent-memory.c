#include "include/jemalloc/jemalloc.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char const *argv[])
{
  printf("[+] Alloc buffer1 size of 8\n");
  char *buffer1 = malloc(sizeof(char) * 8);
  printf("[+] Alloc buffer2 size of 16\n");
  char *buffer2 = malloc(sizeof(char) * 16);
  printf("[+] Alloc buffer3 size of 8\n");
  char *buffer3 = malloc(sizeof(char) * 8);

  memset(buffer1, 'A', 7);
  memset(buffer2, 'B', 15);
  memset(buffer3, 'C', 7);

  printf("[%p] buffer1 : %s\n", buffer1, buffer1);
  printf("[%p] buffer2 : %s\n", buffer2, buffer2);
  printf("[%p] buffer3 : %s\n", buffer3, buffer3);

  printf("\n[+] Overwrite adjacent memory from buffer1 with 'D'\n\n");
  memset(buffer1, 'D', 12);

  printf("[%p] buffer1 : %s\n", buffer1, buffer1);
  printf("[%p] buffer2 : %s\n", buffer2, buffer2);
  printf("[%p] buffer3 : %s\n", buffer3, buffer3);
  return EXIT_SUCCESS;
}
