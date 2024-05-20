all: build/carg-os

clean:
	@rm -rf build

init:
	@git clone https://github.com/carg-os/init.git

karg:
	@git clone https://github.com/carg-os/karg.git

lua:
	@git clone https://github.com/carg-os/lua.git

newlib:
	@git clone https://github.com/carg-os/newlib.git

build: | init karg
	@mkdir build
	@cmake \
		-B build \
		-D CMAKE_TOOLCHAIN_FILE=cmake/toolchain.cmake \
		-D PLATFORM=$(PLATFORM)

newlib/build: | newlib
	@mkdir newlib/build; \
	 cd newlib/build; \
	 ../configure \
		--target=riscv-cargos \
		AR_FOR_TARGET=ar \
		CC_FOR_TARGET=clang \
        RANLIB_FOR_TARGET=ranlib \
		CFLAGS_FOR_TARGET=" \
			-target riscv64-unknown-elf \
			-march=rv64gc \
			-mcmodel=medany \
			-D__GLIBC_USE\(...\)=0 \
		"

FORCE:

build/carg-os: FORCE | build lua newlib/build
	@cd newlib/build; make
	@make \
		-C lua \
		CC=clang \
		SYSCFLAGS=" \
			-target riscv64-unknown-elf \
			-march=rv64gc \
			-mcmodel=medany \
			-D__GLIBC_USE\(...\)=0 \
		" \
		LIBC_INCLUDE=$(CURDIR)/newlib/newlib/libc/include \
		generic
	@cmake --build build

run: build/carg-os
	@qemu-system-riscv64 -M virt -nographic -kernel build/carg-os
