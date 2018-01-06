// $gcc -o posix_gettime posix_gettime.c -lrt
// $./posix_gettime
#include <stdio.h>
#include <time.h>

int main(int argc, char **argv) {
    int index;
    struct timespec start;
    struct timespec stop;

    int i, j, k;
    int a[64], b[64], c[64];

    for (i=0; i<64; i++){
        a[i] = 0;
        b[i] = 0;
        c[i] = 0;
    }

    clock_gettime(CLOCK_MONOTONIC,&start);
    __asm__ __volatile__("" : : : "memory");

    printf("input A matrix\n");
    for (i = 0; i < 8; i++) {
      for (j = 0; j < 8; j++) {
      scanf("%d", &a[8*i+j]);
      }
    }
    printf("input B matrix\n");
    for (i = 0; i< 8; i++) {
      for (j = 0; j< 8; j++) {
      scanf("%d", &b[8*i+j]);
      }
    }

    //Calcurate
    int N=8;
    for (i = 0; i < N; i++){ //行
        for (j = 0; j < N; j++){//列
            for (k = 0; k < N; k++){//各要素
                c[i*N+j]+=a[i*N+k]*b[k*N+j];
            }
        }
    }

    printf("\n Answer\n");
    for (i=0; i<8; i++){
        for (j=0; j<8; j++){
            printf("%d ", c[i*8+j]);
        }
        printf("\n");
    }
    printf("END\n");

    __asm__ __volatile__("" : : : "memory");
    clock_gettime(CLOCK_MONOTONIC,&stop);
  
    printf("%ld\n", stop.tv_nsec-start.tv_nsec) ;

    return 0;
}


    


