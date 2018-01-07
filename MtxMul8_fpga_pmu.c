#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <assert.h>
#include <sys/mman.h>
#include <fcntl.h>
#include "pmon_ca9.h"


int main(){
    unsigned long start, end;

    int inbyte_in;
    int val;
    int fd;
    volatile unsigned int *base;

    //UIO0
    fd = open("/dev/uio0", O_RDWR);
    if (fd<1) {
        fprintf(stderr, "/dev/uio0 open error\n");
        exit(-1);
    }
    base = (volatile unsigned int *)mmap(NULL, 0x10000, PROT_READ|PROT_WRITE,MAP_SHARED, fd, 0);/*FPGAのレジスタをマッピング*/
    
    if (!base){
        fprintf(stderr, "register mmap error \n");
        exit(-1);
    }

    int i, j;
    int a[8][8], b[8][8];
    
    __asm__ __volatile__("" : : : "memory");
    start = pmon_start_cycle_counter();

    printf("input A matrix\n");
    for (i = 0; i < 8; i++) {
      for (j = 0; j < 8; j++) {
      scanf("%ud", &base[8*i+j]);
      }
     }
    printf("input B matrix\n");
    for (i = 0; i< 8; i++) {
      for (j = 0; j< 8; j++) {
      scanf("%ud", &base[8*i+j+64]);
      }
    }

    __asm__ __volatile__("" : : : "memory");

    printf("START\n");
    base[192] = 1;

    while(base[192]!=0b11){
      printf("*");
    }

    printf("\n Answer\n");
    for (i=0; i<8; i++){
        for (j=0; j<8; j++){
            val = base[128+i*8+j];    

    printf("\n Answer\n");
    for (i=0; i<8; i++){
        for (j=0; j<8; j++){
            val = base[128+i*8+j];
            printf("%d ", val);
        }
        printf("\n");
    }
    base[192]=0;
    printf("END \n\n\n");


    __asm__ __volatile__("" : : : "memory");
    end = pmon_read_cycle_counter();
    printf("time = %ld", end - start);

    munmap((void *)base, 0x1000);
}          