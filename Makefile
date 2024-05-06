all: build/carg-os

clean:
	@rm -rf build
	@make -C lua clean
	@rm -rf newlib/build

init:
	@git clone https://github.com/carg-os/init.git

karg:
	@git clone https://github.com/carg-os/karg.git

lua:
	@git clone https://github.com/carg-os/lua.git

newlib:
	@git clone https://github.com/carg-os/newlib.git

PLATFORM = QEMU

build: | init karg
	@mkdir build
	@cmake -B build -D CMAKE_TOOLCHAIN_FILE=cmake/toolchain.cmake -D PLATFORM=$(PLATFORM)

newlib/build: | newlib
	@mkdir newlib/build; cd newlib/build; ../configure --target=riscv-cargos \
		AR_FOR_TARGET=riscv64-unknown-elf-ar \
		CC_FOR_TARGET=riscv64-unknown-elf-gcc \
		RANLIB_FOR_TARGET=riscv64-unknown-elf-ranlib

FORCE:

build/carg-os: FORCE | build lua newlib/build
	@cd newlib/build; make
	@make -C lua LIBC_INCLUDE=$(CURDIR)/newlib/newlib/include generic
	@cmake --build build

run: build/carg-os
	@qemu-system-riscv64 -M virt -nographic -kernel build/carg-os
