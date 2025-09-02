#  xiaomi_capricorn_msm8996pro_kernel_workspace
This repository contains all required file to build kernel for Xiaomi 5s(capricorn). <br/>

# How to use
You need to sync the submodule and enter `capricorn-kernel` directory. <br/>
Then run
```bash
mkdir out
cp ../config-stable out/.config
bash build.sh -j$(nproc) && bash build.sh bootimg
```
After the build complete, you will see `out/boot.img`. <br/>
Then run `bash build.sh flash` to flash `boot` to your device.
