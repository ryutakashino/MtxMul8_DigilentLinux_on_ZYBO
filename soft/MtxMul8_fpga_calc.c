#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <assert.h>
#include <sys/mman.h>
#include <fcntl.h>
#include <time.h>


int main(){
    struct timespec start;
    struct timespec stop;


    int fd;
    volatile unsigned long *base;

    //UIO0
    fd = open("/dev/uio0", O_RDWR);
    if (fd<1) {
        fprintf(stderr, "/dev/uio0 open error\n");
        exit(-1);
    }
    base = (volatile unsigned long *)mmap(NULL, 0x10000, PROT_READ|PROT_WRITE,MAP_SHARED, fd, 0);/*FPGAのレジスタをマッピング*/
    
    if (!base){
        fprintf(stderr, "register mmap error \n");
        exit(-1);
    }

    int N = 8;
    int i, j;
    int a[64], b[64], c[64];
    

    // printf("input A matrix\n");
    for (i = 0; i < N; i++) {
        for (j = 0; j < N; j++) {
            scanf("%lu", &base[N*i+j]);
        }
    }
    // printf("input B matrix\n");
    for (i = 0; i< N; i++) {
        for (j = 0; j< N; j++) {
            scanf("%lu", &base[N*i+j+64]);
        }
    }
    
    __asm__ __volatile__("" : : : "memory");
    clock_gettime(CLOCK_MONOTONIC,&start);
    // printf("START\n");
    base[192] = 1;
    while(base[192]!=0b11){
    //   printf("*");
    }

    // printf("Answer\n");
    for (i=0; i<N; i++){
        for (j=0; j<N; j++){
            // printf("%lu ", base[128+i*8+j])
            c[i*N+j] = base[128+i*N+j];
        }
        // printf("\n");
    }
    base[192] = 0;
    // printf("END \n\n\n");

    __asm__ __volatile__("" : : : "memory");
    clock_gettime(CLOCK_MONOTONIC,&stop);
    printf("%ld\n", stop.tv_nsec-start.tv_nsec) ;

    munmap((void *)base, 0x1000);
}          