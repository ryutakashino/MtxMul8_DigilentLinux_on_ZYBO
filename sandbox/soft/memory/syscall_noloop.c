#include <stdio.h>
#include <stdlib.h>
#include <time.h>

int main(int argc, char *argv[])
{
    int i,j,k,l;
    int N = 8;
    unsigned long a[64], b[64], c[64];

    struct timespec start;
    struct timespec stop;
    
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
        fscanf(fp, "%lu", &a[i] );
    }

    for (i = 0; i < 64; i++){
        fscanf(fp, "%lu", &b[i] );
    }

    clock_gettime(CLOCK_MONOTONIC,&start);

    //initialize
    for (i=0; i<64; i++){
        c[i] = 0;
    }

    //calcurate
    for (i = 0; i < N; i++){ //row
        for (j = 0; j < N; j++){//clomun
            for (k = 0; k < N; k++){//element
                c[i*N+j]+=a[i*N+k]*b[k*N+j];
            }
        }
    }
    fclose(fp);
    
    clock_gettime(CLOCK_MONOTONIC,&stop);

    double ns_time = stop.tv_nsec-start.tv_nsec;
    printf("%lf\n",ns_time) ;

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