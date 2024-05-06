cmake_minimum_required(VERSION 3.29)
project(carg-os C)

if (NOT PLATFORM)
    set(PLATFORM QEMU)
endif()

set(LIBC_INCLUDE ${PROJECT_SOURCE_DIR}/newlib/libc/include)
set(LUA_INCLUDE ${PROJECT_SOURCE_DIR}/lua/src)
add_subdirectory(karg)
add_subdirectory(init)

add_executable(carg-os src/dummy.c)
target_link_options(carg-os PRIVATE -nostdlib -T ${PROJECT_SOURCE_DIR}/karg/kernel.ld)
target_link_libraries(carg-os
    karg
    ${PROJECT_SOURCE_DIR}/newlib/build/riscv-cargos/newlib/crt0.o
    init
    ${PROJECT_SOURCE_DIR}/lua/src/liblua.a
    ${PROJECT_SOURCE_DIR}/newlib/build/riscv-cargos/newlib/libc.a
    ${PROJECT_SOURCE_DIR}/newlib/build/riscv-cargos/newlib/libm.a
    gcc
)
