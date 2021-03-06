// $gcc -o posix_gettime posix_gettime.c -lrt
// $./posix_gettime
#include <stdio.h>
#include "pmon_ca9.h"

int main(int argc, char **argv) {
    unsigned long start, end;
    __asm__ __volatile__("" : : : "memory");
    start = pmon_start_cycle_counter();

    int N = 8;
    int i, j, k;
    unsigned long a[64], b[64], c[64];

    for (i=0; i<64; i++){
        a[i] = 0;
        b[i] = 0;
        c[i] = 0;
    }


    // printf("input A matrix\n");
    for (i = 0; i < N; i++) {
        for (j = 0; j < N; j++) {
            scanf("%lu", &a[N*i+j]);
        }
    }
    // printf("input B matrix\n");
    for (i = 0; i< N; i++) {
        for (j = 0; j< N; j++) {
            scanf("%lu", &b[N*i+j]);
        }
    }

    //Calcurate
    for (i = 0; i < N; i++){ //row
        for (j = 0; j < N; j++){//clomun
            for (k = 0; k < N; k++){//element
                c[i*N+j]+=a[i*N+k]*b[k*N+j];
            }
        }
    }

    // printf("\n Answer\n");
    // for (i=0; i<8; i++){
    //     for (j=0; j<8; j++){
    //         printf("%d ", c[i*8+j]);
    //     }
    //     printf("\n");
    // }
    // printf("END\n");

    __asm__ __volatile__("" : : : "memory");
    end = pmon_read_cycle_counter();
    printf("time = %ld\n", end - start);

    return 0;
}