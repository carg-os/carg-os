all: build/carg-os

clean:
	@rm -rf build

karg:
	@git clone https://github.com/carg-os/karg.git

init:
	@git clone https://github.com/carg-os/init.git

libc:
	@git clone https://github.com/carg-os/libc.git

PLATFORM = QEMU

build: | karg init libc
	@mkdir build
	@cmake -B build -D CMAKE_TOOLCHAIN_FILE=cmake/toolchain.cmake -D PLATFORM=$(PLATFORM)

FORCE:

build/carg-os: FORCE | build
	@cmake --build build

run: build/carg-os
	@qemu-system-riscv64 -M virt -nographic -kernel build/carg-os
