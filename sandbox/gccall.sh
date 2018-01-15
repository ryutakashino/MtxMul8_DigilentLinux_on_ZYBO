# Usage: chmod 777 ./gccall.sh
#        ./gccall.sh
gcc pmu.c -o pmu
gcc pmu_noloop.c -o pmu_noloop
gcc syscall.c -o syscall -lrt
gcc syscall_noloop.c -o syscall_noloop -lrtp