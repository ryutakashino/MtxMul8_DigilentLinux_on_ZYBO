//http://blog.kmckk.com/archives/3971916.html からコピペして、一部のみ変更
// pmon_ca9.h
// #include "pmon_ca9.h" として、
//    start = pmon_start_cycle_counter();
//    x = func(1000); のような何らかの処理
//    end = pmon_read_cycle_counter();
//    printf("time = %ld, x = %d\n", end - start, x);
// 上記のようにすることで挟まれた処理の間に要したクロック数がもとまる。
// t = 1/f = 1,000,000,000ns/650,000,000Hz = 1.53846153846ns/cycle
// Hz == cycle/sec 
#ifndef __KMC_PMON_CA9_H
#define __KMC_PMON_CA9_H

/* Performance Monitor Control Register of Cortex A9*/
#define PMCR_D 3
#define PMCR_C 2
#define PMCR_E 0
#define PMCNTENSET_C 31


volatile __inline__ static unsigned long __attribute__((always_inline))
pmon_start_cycle_counter()
{
    unsigned long x;
    
    x = 1 << PMCNTENSET_C;
    asm volatile("mcr   p15, 0, %0, c9, c12, 1" :: "r" (x));

    asm volatile("mrc   p15, 0, %0, c9, c12, 0" : "=r" (x));
    x |= ((0 << PMCR_D) | (1 << PMCR_C) | (1 << PMCR_E));   //64分周はさせない。
    asm volatile("mcr   p15, 0, %0, c9, c12, 0" :: "r" (x));

    asm volatile("mrc   p15, 0, %0, c9, c13, 0" : "=r" (x));
    return x;
}

volatile __inline__ static unsigned long __attribute__((always_inline))
pmon_read_cycle_counter()
{
    unsigned long x;
    asm volatile ("mrc  p15, 0, %0, c9, c13, 0": "=r" (x));
    return x;
}

#endif /* __KMC_PMON_CA9_H */    