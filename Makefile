all: build/karg/karg

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
		AR_FOR_TARGET=riscv64-unknown-elf-ar \
		CC_FOR_TARGET=riscv64-unknown-elf-gcc \
		RANLIB_FOR_TARGET=riscv64-unknown-elf-ranlib \
		CFLAGS_FOR_TARGET="-mcmodel=medany"

FORCE:

build/karg/karg: FORCE | build lua newlib/build
	@cd newlib/build; \
	 make
	@make \
		-C lua \
		CC=riscv64-unknown-elf-gcc \
		SYSCFLAGS="-mcmodel=medany" \
		LIBC_INCLUDE=$(CURDIR)/newlib/newlib/libc/include \
		generic
	@cmake --build build

run: build/karg/karg
	@qemu-system-riscv64 \
		-M virt \
		-nographic \
		-kernel build/karg/karg
