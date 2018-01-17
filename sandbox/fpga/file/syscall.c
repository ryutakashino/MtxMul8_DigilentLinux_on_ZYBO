#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <unistd.h>
#include <assert.h>
#include <sys/mman.h>
#include <fcntl.h>

int main(int argc, char *argv[])
{
    int i,j,k,l;
    int N = 8;
    unsigned long a[64], b[64], c[64];

    struct timespec start;
    struct timespec stop;
    
    int fd;
    volatile unsigned long *fpga_reg;

    //UIO0
    fd = open("/dev/uio0", O_RDWR);
    if (fd<1) {
        fprintf(stderr, "/dev/uio0 open error\n");
        exit(-1);
    }
    fpga_reg = (volatile unsigned long *)mmap(NULL, 0x10000, PROT_READ|PROT_WRITE,MAP_SHARED, fd, 0);/*FPGA縺ｮ繝ｬ繧ｸ繧ｹ繧ｿ繧偵・繝・ヴ繝ｳ繧ｰ*/
    
    if (!fpga_reg){
        fprintf(stderr, "register mmap error \n");
        exit(-1);
    }

    clock_gettime(CLOCK_MONOTONIC,&start);
    //1000回実行することでオーバーヘッドを小さくする。
    for (l=0; l<1000; l++){
        
        //read file into array
        FILE *fp;
        if (argc != 2) {
            fprintf(stderr, "Missing file argument\n");
            exit (0);
        }
        fp = fopen(argv[1], "r");
        if (fp == NULL){
            printf("Error Reading File\n");
            exit (0);
        }

        //与えられるfileは128のunsigned int型の数字がスペースを開けて並んでいるものとする。
        //上64個が行列Aで、下64個が行列Bであるものとみなす。
        //fileの形式が正しくない場合のエラー処理は行わない。
        for (i = 0; i < 64; i++){
            fscanf(fp, "%lu", &fpga_reg[i]);
        }

        for (i = 0; i < 64; i++){
            fscanf(fp, "%lu", &fpga_reg[i+64]);
        }

        //initialize
        for (i=0; i<64; i++){
            c[i] = 0;
        }

         // printf("START\n");
        fpga_reg[192] = 1;
        while(fpga_reg[192]!=0b11){
        //   printf("*");
        }

        // printf("Answer\n");
        for (i=0; i<N; i++){
            for (j=0; j<N; j++){
                c[i*N+j] = fpga_reg[128+i*N+j];
            }
            // printf("\n");
        }
        fclose(fp);
    }    
    clock_gettime(CLOCK_MONOTONIC,&stop);

    //1回あたりの速度を求めるために1000で割る。
    double ns_time = stop.tv_nsec-start.tv_nsec;
    printf("%lf\n",ns_time/1000) ;

    // printf("\n Answer\n");
    // for (i=0; i<8; i++){
    //     for (j=0; j<8; j++){
    //         printf("%lu ", c[i*8+j]);
    //     }
    //     printf("\n");
    // }
    // printf("END\n");
    
    return 0;
}