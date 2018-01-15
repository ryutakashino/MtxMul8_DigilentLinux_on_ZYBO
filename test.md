### Digilent Linux のビルド


以下を追加
```
96  git clone -b master-next https://github.com/DigilentInc/Linux-Digilent-Dev.git
97  git clone -b master-next https://github.com/DigilentInc/u-boot-Digilent-Dev.git
130  cd ../u-boot-Digilent-Dev/
131  make ARCH=arm CROSS_COMPILE=arm-xilinx-linux-gnueabi- zynq_zybo_config
132  make ARCH=arm CROSS_COMPILE=arm-xilinx-linux-gnueabi-
133  cp u-boot u-boot.elf
134  cd ../Linux-Digilent-Dev/
138  PATH=:$PATH:../u-boot-Digilent-Dev/tools/
139  make ARCH=arm CROSS_COMPILE=arm-xilinx-linux-gnueabi- UIMAGE_LOADADDR=0x8000 uImage
140  cp arch/arm/boot/dts/zynq-zybo.dts . 
149  vim zynq-zybo.dts 
150  scripts/dtc/dtc -I dts -O dtb -o devicetree.dtb zynq-zybo.dts 
151  history

zynq-zybo.dtsでは、以下を追加する。
-----44-----
bootargs = "console=ttyPS0, 115200 root=/dev/mmcblk0p2 rw earlyprintk rootfstype=ext4 rootwait devtmpfs.mount=1 uio_pdrv_genirq.of_if=generic-uio"
-----65-----
operating-points = <650000 1000000>;
-----333----
axi_slave@43c00000 {
        compatible = "generic-uio";
        reg = <0x43c00000 0x10000 >;
};

```

SDカードは2つのあれを作る。パーティション

```
  173  cp ../../sf_D_DRIVE/linaro-precise-ubuntu-desktop-20121124-560.tar.gz ~/workspace/ZYBO_Linux/
  174  cd ~/workspace/ZYBO_Linux/
  175  ls
  176  sudo tar --strip-components=3 -C /media/kashino/ROOT_FS -xzpf linaro-precise-ubuntu-desktop-20121124-560.tar.gz binary/boot/filesystem.dir 

```
これでROOT_FSにLinuxのよくみるディレクトリ郡が生成される。  
http://marsee101.blog19.fc2.com/blog-entry-3079.html#comment2723


uImageとdevicetree.dtb、uEnv.txt、Boot.binをSDカードに入れてZYBOを起動する。
