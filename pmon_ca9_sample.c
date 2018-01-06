//pmon_ca9.hの使用例。sleep関数はあまりうまくいかないみたい。
// 実際に出力
// root@linaro-ubuntu-desktop:~/mesure_time/pmu# gcc test.c
// root@linaro-ubuntu-desktop:~/mesure_time/pmu# ./a.out
// Illegal instruction
// root@linaro-ubuntu-desktop:~/mesure_time/pmu# insmod pmuser.ko
// Enabled accessing Performance Monitoring Unit from user space
// root@linaro-ubuntu-desktop:~/mesure_time/pmu# ./a.out
// time = 3300056, x = 33897

#include <stdio.h>
#include "pmon_ca9.h"

int func(int x)
{
    int sum = 0;
    int i;
    for (i = 1; i <= x; i++) {
        sum += i;
    }
    return sum;
}

int main()
{
    unsigned long start, end;
    int x;

    start = pmon_start_cycle_counter();
    __asm__ __volatile__("" : : : "memory");
//    x = func(200000000);
    sleep(5);
    __asm__ __volatile__("" : : : "memory");
    end = pmon_read_cycle_counter();
    printf("time = %ld, x = %d\n", end - start, x);

    return x;
}