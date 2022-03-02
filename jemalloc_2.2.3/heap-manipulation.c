#include "include/jemalloc/jemalloc.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define TSIZE   0x10            /* target size class */
#define NALLOC  500             /* number of allocations */
#define NFREE   (NALLOC / 10)   /* number of deallocations */

char *foo[NALLOC];
char *bar[NALLOC];


int main() {
    printf("step 1: controlled allocations of victim objects\n");

    for(int i = 0; i < NALLOC; i++)
    {
	foo[i] = malloc(TSIZE);
	printf("foo[%d]:\t\t%p\n", i, foo[i]);
    }

    printf("step 2: creating holes in between the victim objects\n");

    for(int i = (NALLOC - NFREE); i < NALLOC; i += 2)
    {
	printf("freeing foo[%d]:\t%p\n", i, foo[i]);
	free(foo[i]);
    }

    printf("step 3: fill holes with vulnerable objects\n");

    for(int i = (NALLOC - NFREE + 1); i < NALLOC; i += 2)
    {
	bar[i] = malloc(TSIZE);
	printf("bar[%d]:\t%p\n", i, bar[i]);
    }
}
