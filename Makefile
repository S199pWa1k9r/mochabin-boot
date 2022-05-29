#
# Makefile for build GlobalScale u-boot
# Copyright (c) 2022, s199p.wa1k9er@gmil.com aka SleepWalker
#
PWD = ${CURDIR}
COM ?= ${PWD}/bin/gcc-linaro-7.3.1-2018.05-x86_64_aarch64-linux-gnu/bin/aarch64-linux-gnu- 

ATF ?= ${PWD}/globalscale/atf-marvell
DDR ?= ${PWD}/globalscale/mv-ddr-marvell
UBT ?= ${PWD}/globalscale/u-boot-marvell

SCP ?= ${PWD}/globalscale/binaries-marvell/mrvl_scp_bl2.img

PAR ?= USE_COHERENT_MEM=0 LOG_LEVEL=20 SECURE=0
DEB ?= 0
RAM ?= 1	# 8Gbite RAM

.PHONY:	all
all:	get-repos release

get-repos:
	git submodule update --init --recursive

boot:	${UBT}/.config ${UBT}/u-boot.bin

${UBT}/.config: 
	@echo " => Configuring U-boot"
	ls -lsa ${UBT}
	make -C ${UBT} gti_mochabin-88f7040_defconfig

${UBT}/u-boot.bin: ${UBT}/.config
	@echo " => Building U-boot"
	make -C ${UBT} DEVICE_TREE=armada-7040-mochabin 

fit:	${UBT}/u-boot.bin
	@echo " => Building U-boot FIT"
	make -C ${ATF} CROSS_COMPILE=${COM} MV_DDR_PATH=${DDR} SCP_BL2=${SCP} \
	BL33=${UBT}/u-boot.bin \
	${PAR} DEBUG=${DEB} DDR_TOPOLOGY=${RAM} PLAT=a70x0_mochabin \
	all fip mrvl_flash

release/mochabin-8g-boot.bin:	boot
	@mkdir -p release
	@make clean_fit
	@make fit RAM=1
	@cp ${PWD}/globalscale/atf-marvell/build/a70x0_mochabin/release/flash-image.bin release/mochabin-8g-boot.bin

release/mochabin-4g-boot.bin:	boot
	@mkdir -p release
	@make clean_fit
	@make fit RAM=0
	@cp ${PWD}/globalscale/atf-marvell/build/a70x0_mochabin/release/flash-image.bin release/mochabin-4g-boot.bin

release:	release/mochabin-8g-boot.bin release/mochabin-4g-boot.bin
	@make show

show:
	@ls -lsa ${PWD}/release

clean_fit:
	@rm -rf ${PWD}/globalscale/atf-marvell/build

clean_boot:
	@make -C ${UBT} clean

clean_release:
	@rm -rf release

clean:
	@make clean_fit
	@make clean_boot
	@make clean_release
