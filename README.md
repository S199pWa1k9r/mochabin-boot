##MochaBin-5G U-boot

##Build Instruction

###Build system requirements

Before building the source code, you should setup your build environment. 
Our recommended host platform is Ubuntu v18.04.4 (64 bits), and you can launch the below commands to install related packages.

     sudo apt-get update
     sudo apt-get install make binutils build-essential gcc g++ \
       bash patch gzip bzip2 perl tar cpio python zlib1g-dev \
       gawk ccache gettext libssl-dev libncurses5 minicom git \
       bison flex device-tree-compiler gcc-arm-linux-gnueabi

###Download the latest source code

You can get the latest MOCHAbin source code from GlobaScale GitHub https://github.com/globalscaletechnologies . 
You can download the source code manually.

     make get-repos

###Get the cross-compiler

For MOCHAbin, we use linaro-7.3.1 (aarch64) toolchain, you can download the toolchain from linaro website.

     wget https://releases.linaro.org/components/toolchain/binaries/7.3-2018.05/aarch64-linux-gnu/gcc-linaro-7.3.1-2018.05-x86_64_aarch64-linux-gnu.tar.xz
     mkdir -p bin
     tar -xvJf gcc-linaro-7.3.1-2018.05-x86_64_aarch64-linux-gnu.tar.xz -C bin/
     rm gcc-linaro-7.3.1-2018.05-x86_64_aarch64-linux-gnu.tar.xz

###Build the bootloader

     make boot
     make release

