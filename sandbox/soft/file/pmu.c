#include <stdio.h>
#include <stdlib.h>
#include "pmon_ca9.h"

int main(int argc, char *argv[])
{
    int i,j,k,l;
    int N = 8;
    unsigned long a[64], b[64], c[64];

    //時間測定用の変数
    unsigned long start, end;
    unsigned long r;//レジスタの値を格納
    
    //illigal instruction対策
    asm volatile ("mrc p15, 0, %0, c9, c14, 0": "=r"(r));
    if (r==0) exit(1);

    start = pmon_start_cycle_counter();
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
            fscanf(fp, "%lu", &a[i] );
        }

        for (i = 0; i < 64; i++){
            fscanf(fp, "%lu", &b[i] );
        }

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
    }    
    end = pmon_read_cycle_counter();

    //1回あたりの速度を求めるために1000で割る。
    double time = end - start;
    double ns = (time * 20 / 13)/1000;
    printf("%lf\n",ns);

    // printf("\n Answer\n");
    // for (i=0; i<8; i++){
    //     for (j=0; j<8; j++){
    //         printf("%lu ", c[i*8+j]);
    //     }
    //     printf("\n");
    // }
    // printf("END\n");

    //サイクルカウンタをリセットして、PMUを停止する。下一桁の値のみが関係している。
    asm volatile ("mrc p15, 0, %0, c9, c14, 0":: "r"(0x410930004));
    return 0;
}