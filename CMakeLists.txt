cmake_minimum_required(VERSION 3.29)
project(carg-os C)

set(LIBC_INCLUDE ${PROJECT_SOURCE_DIR}/newlib/newlib/libc/include)
set(LUA_INCLUDE ${PROJECT_SOURCE_DIR}/lua/src)
add_subdirectory(karg)
add_subdirectory(init)

target_link_libraries(init
    ${PROJECT_SOURCE_DIR}/newlib/build/riscv-cargos/newlib/crt0.o
    ${PROJECT_SOURCE_DIR}/lua/src/liblua.a
    ${PROJECT_SOURCE_DIR}/newlib/build/riscv-cargos/newlib/libc.a
    ${PROJECT_SOURCE_DIR}/newlib/build/riscv-cargos/newlib/libm.a
    gcc
)
