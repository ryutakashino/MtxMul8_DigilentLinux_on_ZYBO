#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <assert.h>
#include <sys/mman.h>
#include <fcntl.h>
#include "pmon_ca9.h"


int main(){
    unsigned long start, end;


    int fd;
    volatile unsigned long *base;

    //UIO0
    fd = open("/dev/uio0", O_RDWR);
    if (fd<1) {
        fprintf(stderr, "/dev/uio0 open error\n");
        exit(-1);
    }
    base = (volatile unsigned long *)mmap(NULL, 0x10000, PROT_READ|PROT_WRITE,MAP_SHARED, fd, 0);/*FPGA縺ｮ繝ｬ繧ｸ繧ｹ繧ｿ繧偵・繝・ヴ繝ｳ繧ｰ*/
    
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

    //__asm__ __volatile__("" : : : "memory");
    __asm__ __volatile__("" : : : "memory");
    start = pmon_start_cycle_counter();
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
    end = pmon_read_cycle_counter();
//    printf("time = %ld\n", end - start);
    double time = end - start;
    double ns = time * 20 / 13;
    printf("%lf\n",ns);

    munmap((void *)base, 0x1000);
}          
