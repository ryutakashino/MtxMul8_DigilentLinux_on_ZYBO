# Usage: chmod 777 ./exe.sh
#        ./exe.sh

cp ../../pmuser.ko ./
cp ../../mtx8x8_gen.c ./
cp ../../pmon_ca9.h ./


insmod pmuser.ko
gcc mtx8x8_gen.c -o mtx_gen
gcc pmu.c -o pmu
gcc pmu_noloop.c -o pmu_noloop
gcc syscall.c -o syscall -lrt
gcc syscall_noloop.c -o syscall_noloop -lrt

for i in {1..1500};
do
    ./mtx_gen > tmp
    rslt = $(./pmu tmp)
    echo ${rslt} >> pmu_data
done

for i in {1..1500};
do
    ./mtx_gen > tmp
    rslt = $(./pmu_noloop tmp)
    echo ${rslt} >> pmu_noloop_data
done

for i in {1..1500};
do
    ./mtx_gen > tmp
    rslt = $(./syscall tmp)
    if [ $rslt > 0]; then
        echo ${rslt} >> syscall_data
    fi
done

for i in {1..1500};
do
    ./mtx_gen > tmp
    rslt = $(./syscall_noloop tmp)
    if [ $rslt > 0]; then
        echo ${rslt} >> syscall_noloop_data
    fi
done
